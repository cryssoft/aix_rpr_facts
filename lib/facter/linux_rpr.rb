#
#  FACT(S):     linux_rpr
#
#  PURPOSE:     This custom fact returns a simple int with the epoch seconds
#		time of the last password rotation for the root account.
#
#  RETURNS:     (hash)
#
#  AUTHOR:      Chris Petersen, Crystallized Software
#
#  DATE:        May 25, 2021
#
#  NOTES:       Mostly a copy of aix_rpr.rb with the tweaks Linux needs.
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
Facter.add(:linux_rpr) do
    #  This only applies to the AIX operating system
    confine :kernel => 'Linux'

    #  Define a ridiculous value for our default return
    l_linuxRPR = '0'

    #  Do the work
    setcode do
        #  Run the command to look through the process list for the Tidal daemon
        l_lines = Facter::Util::Resolution.exec('/bin/cat /etc/shadow 2>/dev/null')

        #  Loop over the lines that were returned
        l_lines && l_lines.split("\n").each do |l_oneLine|
            #  Strip leading and trailing whitespace and split colons
            l_list = l_oneLine.strip().split(':')
            if (l_list[0] == 'root')
                l_temp     = 86400 * l_list[2].to_i
                l_linuxRPR = l_temp.to_s
            end
        end

        #  Implicitly return the contents of the variable
        l_linuxRPR
    end
end
