#
#  FACT(S):     aix_rpr
#
#  PURPOSE:     This custom fact returns a simple string with the epoch seconds
#		time of the last password rotation for the root account.
#
#  RETURNS:     (hash)
#
#  AUTHOR:      Chris Petersen, Crystallized Software
#
#  DATE:        February 9, 2021
#
#  NOTES:       Myriad names and acronyms are trademarked or copyrighted by IBM
#               including but not limited to IBM, PowerHA, AIX, RSCT (Reliable,
#               Scalable Cluster Technology), and CAA (Cluster-Aware AIX).  All
#               rights to such names and acronyms belong with their owner.
#
#-------------------------------------------------------------------------------
#
#  LAST MOD:    (never)
#
#  MODIFICATION HISTORY:
#
#       (none)
#
#-------------------------------------------------------------------------------
#
Facter.add(:aix_rpr) do
    #  This only applies to the AIX operating system
    confine :osfamily => 'AIX'

    #  Define a ridiculous value for our default return
    l_aixRPR = '0'

    #  Do the work
    setcode do
        #  Run the command to look through the process list for the Tidal daemon
        l_lines = Facter::Util::Resolution.exec('/bin/cat /etc/security/passwd -ef 2>/dev/null')

        #  Loop over the lines that were returned
        l_state=0
        l_lines && l_lines.split("\n").each do |l_oneLine|
            #  Strip leading and trailing whitespace and split on remaining whitespace
            l_list = l_oneLine.strip().split()

            #  State machine!
            if (l_state == 0)
              if (l_list[0] == 'root:')
                l_state = 1
              end
            end
            if (l_state == 1)
              if (l_list[0] == 'lastupdate')
                l_aixRPR = l_list[2]
                l_state  = 2
              end
            end
        end

        #  Implicitly return the contents of the variable
        l_aixRPR
    end
end
