xkblayout-state print "Current layout: %s(%e)" | awk '{print toupper($3)}' | sed "s/([^)]*)//g"
