





** LDAP settings** : (put this setting in nginx.conf file, but do the necessary change as per you org).
      
    
   
    ldap_server ldappage {
      url ldap://ldap-org.com/o=ldap.com?mail?sub?(objectClass=*);
      group_attribute uniquemember;
      group_attribute_is_dn on;
          #require group 'cn=anygroup,ou=memberlist,ou=jankingroups,o=ldap.com';
      require valid_user;
      satisfy all;
      }
