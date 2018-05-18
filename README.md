This is in unofficial repository for creating a Docker based on Vitam version 0.15.

If you want to give it a try, you need:
   - a linux OS with at least 8 MB of RAM (CentOS or Debian)
   - docker installed: if not go to https://get.docker.com/

Instructions:
   - Copy this run.sh file
   - Make it executable: sudo chmod +x run.sh
   - Launch it: ./run.sh
   - Inside the container
   - The first time, you need to deploy all the components with the command 'vitam-deploy-all'
       - To start, you type: 'vitam-start'
       - Launch your browser at the adress http://localhost
       - When you relaunch the container, you don't need to redeploy, you have just to type 'vitam-start'
 

Vitam is a French program, for more information: www.programmevitam.fr
If you have any question, ask me: fdeguilhen@gmail.com
