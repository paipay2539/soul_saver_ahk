import sys
import time
from shutil import copyfile
timestamp = str(time.strftime("%Y-%m-%d-%H-%M"))
print(timestamp)
newname = 'sso_backup_'+timestamp+'_branch_axe_auto_multitasking.ahk'
copyfile('AHK_work.ahk', r'backup\\'+newname)
# copyfile(sys.argv[1], r'backup\\'+newname)
