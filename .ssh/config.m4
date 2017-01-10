# Current identity file
IdentityFile ~/.ssh/identity

# Allow local commands to run from ~C !command
PermitLocalCommand yes

m4_ifelse(PH_SYSTEM, CYGWIN, , 
    # Allow sharing of already existing connections (only for non-Cygwin)
    ControlMaster auto
    ControlPath /tmp/ssh-control:%h:%p:%r
)