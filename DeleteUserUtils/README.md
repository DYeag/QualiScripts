# Delete User Utils

Deleting a user from CloudShell is not possible if the user has made any reservations as the database entires are tied to that user acount.

The workaround, NOT ADVISED, is to delete the database entries tied to the account.
    Download deleteReservations.py and edit the file, edit the global variables
    Change START_TIME and END_TIME for span of reservations to delete
    Add usernames into the USERS_TO_DELETE array, only reservations made by these users will be delete
    Change the ADMIN_USERNAME and ADMIN_PASSWORD to correct CloudShell sys admin credentials
    Run
