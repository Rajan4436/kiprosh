# README

Steps to follow to run the app;

* App has 4 roles, 
	
	guest => only read 
	moderator => read and update
	owner => can CRUD
	admin => all access 

* Run bundle and create databases, after that create a user. 

* Inital user has no role provided and as he goes on with app, he will gain the access 

* after sign in user will be landed at home screen where it as 3 tabs stating 
 - My notes (notes he created)
 - Shared notes (notes shared to him by others)
 - Search (to search notes by tag)

* On creating a note he will gain the access on owner on that note itself. he can create tags and share it to other users. 

* The shared notes will be shown in shared notes tab. when you click on any note you will be landed on a page where you will see; actions are available to you according to your role specified by owner.

* If you have moderator access you can also choose people with whom you want to share the note. 

* Note that already shared poeple will also in that list. You can see their access but cannot alter them until you have owner access. 

