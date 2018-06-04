import cloudshell.api.cloudshell_api as cs_api


USERS_TO_DELETE = ['username']
ADMIN_USERNAME = 'admin'
ADMIN_PASSWORD = 'admin'

# Time Format '%m/%d/%Y %H:%M'
# START can be '01/01/2000 00:00', before first database entry
# END can be current date or after, after latest database entry
START_TIME = '01/01/2000 00:00'
END_TIME= '01/01/2019 00:00'


class DeleteReservations:
    def __init__(self):
        pass

    def run_script(self):
        try:
            session = cs_api.CloudShellAPISession('localhost',
                                                  username=ADMIN_USERNAME,
                                                  password=ADMIN_PASSWORD,
                                                  domain='Global')

            res_list = session.GetScheduledReservations(fromTime=START_TIME, untilTime=END_TIME).Reservations
            deleted = 0

            if USERS_TO_DELETE:
                for res in res_list:
                    if res.Owner in USERS_TO_DELETE:
                        deleted += 1
                        session.DeleteReservation(reservationId=res.Id)

            print 'Number of deleted Reservations: ' + str(deleted)

        except Exception:
            print 'Error: please contact Quali for assistance'


###############################################################################
def main():
    try:
        local = DeleteReservations()
        local.run_script()
    except Exception as e:
        print e.message


if __name__ == '__main__':
    main()
