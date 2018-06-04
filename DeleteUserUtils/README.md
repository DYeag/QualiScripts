# Delete User Utils

Deleting a user from CloudShell is not possible if the user has made any reservations as the database entires are tied to that user acount.

The workaround, NOT ADVISED, is to delete the database entries tied to the account.
    download deleteReservations.py and edit the file, edit the global variables
    add a start and end date for span of reservations to delete
    add usernames into the USER array, only reservations made by these users will be deleted
