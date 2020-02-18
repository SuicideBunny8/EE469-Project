# Commit Instructons
1) git add .

- this adds the files to be tracked

2) git commit -m "commit message"

- commits the files to your remote repository. This is 1 level short of the master branch
- if you forget the -m "commit message" it will open a terminal editor. 
- make your commit messages descriptive

3) git push

- this will push the files to the master repository for the internet to access

# Pulling Changes

1) do steps 1 and 2 of the commit instructions

2) git pull

- pulls all of the changes made to the master repository

3) you may run into merge conflicts. That will look like this in your code

<<<<<<< HEAD
changes you have made
=======
code on master branch
>>>>>>> branch id (will look like a random collection of characters)

this can happen when two people make changes to the same lines of code. You will need to remove the arrow and equal sign lines and select which edit you want to keep. That is select the code either above or below the equal signs.