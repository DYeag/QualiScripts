import cloudshell.api.cloudshell_api as cs_api
from platform import system as p_system
from subprocess import PIPE, Popen
import csv


def _cmdline(command):
    process = Popen(
        args=command,
        stdout=PIPE,
        shell=True
    )
    return process.communicate()[0]


def ping(ip):

    try:
        if ip == 'NA':
            return True

        check = False
        packet_Tx = 1
        pass_rate = 51

        my_plat = p_system().lower()
        if my_plat == 'win32' or my_plat == 'windows':
            count_type = 'n'
        else:
            count_type = 'c'

        raw = _cmdline("ping -%s %s %s" % (count_type, packet_Tx, ip))

        if my_plat == 'win32' or my_plat == 'windows':
            raw = raw.split('%')[0]
            raw = raw.split(' ')[-1]
            loss_rate = float(raw[1:])
        else:
            raw = raw.split('%')[0]
            loss_rate = float(raw.split(' ')[-1])

        packet_Rx = 100 - loss_rate

        if packet_Rx >= pass_rate:
            return True
        return False
    except Exception as e:
        return True



session = cs_api.CloudShellAPISession('localhost',
                                       username='admin',
                                       password='admin',
                                       domain='Global')

resources = session.GetResourceList().Resources
csv_data = [['Name', 'IP']]

for each in resources:
    address = each.Address
    if ':Matrix' in each.Address:
        address = each.Address.split(':')[0]
    if each.Address == 'NA' or each.ResourceModelName == 'Generic App Model':
        continue
    if not ping(address):
        csv_data.append([each.Name, each.Address])
        print each.Name, address, each.ResourceModelName

with open('MSFT_unreachable.csv', 'wb') as csvFile:
    writer = csv.writer(csvFile)
    writer.writerows(csv_data)
csvFile.close()

print 'done'