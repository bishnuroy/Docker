#!/bin/bash

# Check for missing binaries (stale symlinks should not happen)
JENKINS_WAR="/usr/lib/jenkins/jenkins.war"
test -r "$JENKINS_WAR" || { echo "$JENKINS_WAR not installed";
        if [ "$1" = "stop" ]; then exit 0;
        else exit 5; fi; }

# Check for existence of needed config file and read it
JENKINS_CONFIG=/etc/sysconfig/jenkins
test -e "$JENKINS_CONFIG" || { echo "$JENKINS_CONFIG not existing";
        if [ "$1" = "stop" ]; then exit 0;
        else exit 6; fi; }
test -r "$JENKINS_CONFIG" || { echo "$JENKINS_CONFIG not readable. Perhaps you forgot 'sudo'?";
        if [ "$1" = "stop" ]; then exit 0;
        else exit 6; fi; }

JENKINS_PID_FILE="/var/run/jenkins.pid"

# Read config
[ -f "$JENKINS_CONFIG" ] && . "$JENKINS_CONFIG"

# Set up environment accordingly to the configuration settings
[ -n "$JENKINS_HOME" ] || { echo "JENKINS_HOME not configured in $JENKINS_CONFIG";
        if [ "$1" = "stop" ]; then exit 0;
        else exit 6; fi; }
[ -d "$JENKINS_HOME" ] || { echo "JENKINS_HOME directory does not exist: $JENKINS_HOME";
        if [ "$1" = "stop" ]; then exit 0;
        else exit 1; fi; }
        candidates="
        /etc/alternatives/java
        /usr/lib/jvm/java-1.6.0/bin/java
        /usr/lib/jvm/jre-1.6.0/bin/java
        /usr/lib/jvm/java-1.7.0/bin/java
        /usr/lib/jvm/jre-1.7.0/bin/java
        /usr/lib/jvm/java-1.8.0/bin/java
        /usr/lib/jvm/jre-1.8.0/bin/java
        /usr/bin/java
        "
        for candidate in $candidates
        do
          [ -x "$JENKINS_JAVA_CMD" ] && break
          JENKINS_JAVA_CMD="$candidate"
        done

        JAVA_CMD="$JENKINS_JAVA_CMD $JENKINS_JAVA_OPTIONS -DJENKINS_HOME=$JENKINS_HOME -jar $JENKINS_WAR"
        PARAMS="--logfile=/var/log/jenkins/jenkins.log --webroot=/var/cache/jenkins/war --daemon"
        [ -n "$JENKINS_PORT" ] && PARAMS="$PARAMS --httpPort=$JENKINS_PORT"
        [ -n "$JENKINS_LISTEN_ADDRESS" ] && PARAMS="$PARAMS --httpListenAddress=$JENKINS_LISTEN_ADDRESS"
        [ -n "$JENKINS_HTTPS_PORT" ] && PARAMS="$PARAMS --httpsPort=$JENKINS_HTTPS_PORT"
        [ -n "$JENKINS_HTTPS_KEYSTORE" ] && PARAMS="$PARAMS --httpsKeyStore=$JENKINS_HTTPS_KEYSTORE"
        [ -n "$JENKINS_HTTPS_KEYSTORE_PASSWORD" ] && PARAMS="$PARAMS --httpsKeyStorePassword='$JENKINS_HTTPS_KEYSTORE_PASSWORD'"
        [ -n "$JENKINS_HTTPS_LISTEN_ADDRESS" ] && PARAMS="$PARAMS --httpsListenAddress=$JENKINS_HTTPS_LISTEN_ADDRESS"
        [ -n "$JENKINS_AJP_PORT" ] && PARAMS="$PARAMS --ajp13Port=$JENKINS_AJP_PORT"
        [ -n "$JENKINS_AJP_LISTEN_ADDRESS" ] && PARAMS="$PARAMS --ajp13ListenAddress=$JENKINS_AJP_LISTEN_ADDRESS"
        [ -n "$JENKINS_DEBUG_LEVEL" ] && PARAMS="$PARAMS --debug=$JENKINS_DEBUG_LEVEL"
        [ -n "$JENKINS_HANDLER_STARTUP" ] && PARAMS="$PARAMS --handlerCountStartup=$JENKINS_HANDLER_STARTUP"
        [ -n "$JENKINS_HANDLER_MAX" ] && PARAMS="$PARAMS --handlerCountMax=$JENKINS_HANDLER_MAX"
        [ -n "$JENKINS_HANDLER_IDLE" ] && PARAMS="$PARAMS --handlerCountMaxIdle=$JENKINS_HANDLER_IDLE"
        [ -n "$JENKINS_ARGS" ] && PARAMS="$PARAMS $JENKINS_ARGS"

        if [ "$JENKINS_ENABLE_ACCESS_LOG" = "yes" ]; then
            PARAMS="$PARAMS --accessLoggerClassName=winstone.accesslog.SimpleAccessLogger --simpleAccessLogger.format=combined --simpleAccessLogger.file=/var/log/jenkins/access_log"
        fi

        RETVAL=0

. /etc/rc.d/init.d/functions

# Copying the jenkins default configuration if needed (In case of host volume mount)
[[ ! -d /var/lib/jenkins/plugins ]] && \
{ tar -xf /root/jenkins-home.tar -C / > /dev/null; chown -R jenkins:jenkins /var/lib/jenkins; }

echo -n "Starting Jenkins "
daemon --user "$JENKINS_USER" --pidfile "$JENKINS_PID_FILE" $JAVA_CMD $PARAMS > /dev/null
RETVAL=$?
if [ $RETVAL = 0 ]; then
    success
    echo > "$JENKINS_PID_FILE"  # just in case we fail to find it
    MY_SESSION_ID=`/bin/ps h -o sess -p $$`
    # get PID
    /bin/ps hww -u "$JENKINS_USER" -o sess,ppid,pid,cmd | \
    while read sess ppid pid cmd; do
        [ "$ppid" = 1 ] || continue
        # this test doesn't work because Jenkins sets a new Session ID
        # [ "$sess" = "$MY_SESSION_ID" ] || continue
        echo "$cmd" | grep $JENKINS_WAR > /dev/null
        [ $? = 0 ] || continue
        # found a PID
        echo $pid > "$JENKINS_PID_FILE"
    done
else
    failure
fi

# Install kubectl binary if not already
[[ ! -f /usr/local/bin/kubectl ]] && \
{ wget https://storage.googleapis.com/kubernetes-release/release/v1.1.4/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl > /dev/null 2>&1 ; chmod +x /usr/local/bin/kubectl; }

# Create kubeconfig file
/usr/local/bin/kubectl config set-cluster default_cluster --server=https://10.100.0.1 --certificate-authority=/run/secrets/kubernetes.io/serviceaccount/ca.crt
/usr/local/bin/kubectl config set-credentials $POD_NS --token=`cat /run/secrets/kubernetes.io/serviceaccount/token` --certificate-authority=/run/secrets/kubernetes.io/serviceaccount/ca.crt
/usr/local/bin/kubectl config set-context default-context --cluster=default_cluster --user=$POD_NS
/usr/local/bin/kubectl config use-context default-context
/usr/local/bin/kubectl config set contexts.default-context.namespace $POD_NS
cp -R /root/.kube /var/lib/jenkins
chown -R jenkins:jenkins /var/lib/jenkins/.kube

# Create SSH keypair for user jenkins
echo -n "Creating ssh keypair for user jenkins"
sed -i '/^jenkins/s/false$/bash/' /etc/passwd > /dev/null
su - jenkins -c 'ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa' > /dev/null
su - jenkins -c 'echo "StrictHostKeyChecking no" > ~/.ssh/config' > /dev/null
success
chmod 600 /var/lib/jenkins/.ssh/id_rsa.pub /var/lib/jenkins/.ssh/config

echo -e "SSH public key\n"
su - jenkins -c 'cat ~/.ssh/id_rsa.pub'
