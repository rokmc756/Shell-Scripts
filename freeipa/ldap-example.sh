# Anonymous bind is the most basic method of client authentication.
# It’s used when there’s no need for authentication, i.e., for certain public areas of the LDAP directory.
# In such cases, a user requires no identity or password for the given operations against the LDAP server.
#
# Let's rocess a search against our server using the ldapsearch command.
# Basically, the ldapsearch command looks for the entries in the LDAP database and returns the results.
# Now, let’s use the -x option with the ldapsearch command for an anonymous bind:
# ldapsearch -x -LLL -H ldap://192.168.0.101/ -b dc=jtest,dc=pivotal,dc=io dn
# ldapsearch -x -h 192.168.0.101 -D uid=jmoon,cn=users,cn=accounts,dc=jtest,dc=pivotal,dc=io -w changeme -b dc=test,dc=pivotal,dc=io
# ldapwhoami -x -H ldap://192.168.0.101/ -D "uid=admin,cn=users,cn=accounts,dc=jtest,dc=pivotal,dc=io" -w changeme

ldapsearch -x -H ldap://192.168.0.101 -D "uid=rmoon,cn=users,cn=accounts,dc=jtest,dc=pivotal,dc=io" -w changeme -b "dc=jtest,dc=pivotal,dc=io"

exit

# Since we’ve not given any Bind DN using the -D option, no password is needed. Consequently, we have an anonymous bind.


# [ Using Simple Bind ]
# In simple authentication or simple bind, the DN of the account entry verifies that account for authentication.
# Along with that, it uses a password to confirm who we are.
# Example of the syntax for a simple bind or plain text authentication command:
ldapsearch -x -H ldap://192.168.0.101 -D "uid=rmoon,cn=users,cn=accounts,dc=jtest,dc=pivotal,dc=io" -w changeme -b "dc=jtest,dc=pivotal,dc=io"


# The values in the above expression as per requirements:
# ldap-server-hostname – LDAP server’s hostname or IP address
# -D – user we want to authenticate with
# -b – DN of the search base
# Now, let’s see this command in action by trying to authenticate our admin user:
ldapsearch -x -D "uid=admin,cn=users,cn=accounts,dc=jtest,dc=pivotal,dc=io" -w changeme -H ldap://192.168.0.101 -b "dc=jtest,dc=pivotal,dc=io"

# dn: uid=admin,cn=users,cn=accounts,dc=jtest,dc=pivotal,dc=io
# dn: cn=admins,cn=groups,cn=accounts,dc=jtest,dc=pivotal,dc=io
# dn: cn=trust admins,cn=groups,cn=accounts,dc=jtest,dc=pivotal,dc=io

# Importantly, the -x option means we use simple authentication. The -W option asks for the password of the user at runtime.


# [ Using SASL ]
# SASL allows LDAP to work with any accepted authentication method between the LDAP client and server:
# ldapsearch -Q -LLL -Y EXTERNAL -H ldapi://192.168.0.101/ -b "dc=jtest,dc=pivotal,dc=io" dn
#
# Since it's working on a local server, the server domain name or IP address can be left out.
# However, the ldapi scheme needs a local connection.
# The -Q option enables the SASL quiet mode, while the -LLL option just formats the output style.
# In addition, the -Y option sets the SASL mechanism for authentication, EXTERNAL in this example.

# [ Authentication Using ldapwhoami Command ]
# Another way to perform LDAP authentication from the command line in Linux is via the ldapwhoami command.
# Basically, it has pretty much the same command structure as the ldapsearch command.
# Also, again anonymous bind can be use, simple bind, and SASL authentication here.

# [ Using Anonymous Bind ]
# First, let’s see how we can use ldapwhoami command with anonymous bind:
ldapwhoami -x -H ldap://192.168.0.101/
# Again, the -x option indicates an anonymous bind. Further, providing no bind DN via the -D option confirms it as such.

# [ Using Simple Bind ]
# Let’s use ldapwhoami to authenticate our admin user using simple bind:
ldapwhoami -x -H ldap://192.168.0.101/ -D "uid=admin,cn=users,cn=accounts,dc=jtest,dc=pivotal,dc=io" -w changeme

# On successful authentication, we see the DN of the user as the output. Otherwise, we see an error message.
# Notably, the options in the above command are the same as the ones used in the ldapsearch case.


# [ Using SASL Authentication ]
# SASL authentication can also work in a similar way to simple bind with ldapwhoami. Again, in this case, we’re dealing with a local server. Thus, we don’t need to put in the server’s IP here:
# ldapwhoami -Y EXTERNAL -H ldapi://192.168.0.101/ -Q
# For successful authentication, we’ll get the uid and gid of the connecting user along with the suffix cn=peercred,cn=external,cn=auth.


# [ ETC ]
# ldapsearch -x -h 192.168.0.101 -b dc=jtest,dc=pivotal,dc=io
# ldapsearch -x -LLL -H ldap://192.168.0.101/ -b dc=jtest,dc=pivotal,dc=io dn

# Failed
# ldapsearch -x -H ldap://192.168.0.101 -D "cn=jmoon,ou=users,dc=jtest,dc=pivotal,dc=io" -w changeme -b "dc=jtest,dc=pivotal,dc=io"


# ipa user-add --first=John --last=Doe jdoe --random

# ldapsearch -x -h 192.168.0.101 -D uid=jmoon,ou=people,dc=jtest,dc=pivotal,dc=io -w changeme -b dc=test,dc=pivotal,dc=io
ldapsearch -x -h 192.168.0.101 -D uid=jmoon,cn=users,cn=accounts,dc=jtest,dc=pivotal,dc=io -w changeme -b dc=test,dc=pivotal,dc=io
ldapsearch -x -h 192.168.0.101 -D uid=rmoon,cn=users,cn=accounts,dc=jtest,dc=pivotal,dc=io -w changeme -b dc=test,dc=pivotal,dc=io

