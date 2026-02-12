echo ===============================================
echo Execute once if .git directory does not exists.
echo Close the Windows if it exists.
echo ===============================================
pause
git init
git config --global user.email "luc.morin@icitechno.com"
git config --global user.name "Luc Morin"
git remote add origin git@github.com:FreeCores-psC/vcdFiles.git  
git remote set-url origin git@github.com:FreeCores-psC/vcdFiles.git
git branch -M main  
git push --set-upstream origin main
