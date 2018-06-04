from cloudshell.workflow.orchestration.setup.default_setup_orchestrator import DefaultSetupWorkflow
from cloudshell.workflow.orchestration.sandbox import Sandbox


def main():

    # Get list of vCenter Static VMs
    sandbox = Sandbox()
    sandbox_resources = sandbox.automation_api.GetReservationDetails(sandbox.id).ReservationDescription.Resources
    static_vms = [res for res in sandbox_resources if res.ResourceModelName == 'vCenter Static VM']

    # If any, iterate through
    if len(static_vms) > 0:
        for static_vm in static_vms:

            if static_vm.Shared:

                # Get number of reservations resource is currently in
                res_count = 0
                for r in sandbox.automation_api.GetResourceAvailability([static_vm.Name], True).Resources:
                    for res in r.Reservations:
                        res_count += 1
                if res_count == 1:

                    # If no other reservation, resource is unshared, powered on, then re shared
                    # Unshared and re shared because shared resources cannot be powered on and off
                    sandbox.automation_api.SetResourceSharedState(sandbox.id, [static_vm.Name], False)
                    sandbox.automation_api.ExecuteResourceConnectedCommand(
                        reservationId=sandbox.id,
                        resourceFullPath=static_vm.Name,
                        commandName='PowerOn',
                        commandTag='power',
                        parameterValues=[],
                        printOutput=True
                    )
                    sandbox.automation_api.SetResourceSharedState(sandbox.id, [static_vm.Name], True)

                # If resource is in another reservation, it should already be powered on and can be skipped here
            else:

                # Power on any non shared resources
                sandbox.automation_api.ExecuteResourceConnectedCommand(
                    reservationId=sandbox.id,
                    resourceFullPath=static_vm.Name,
                    commandName='PowerOn',
                    commandTag='power',
                    parameterValues=[],
                    printOutput=True
                )
    else:
        sandbox.automation_api.WriteMessageToReservationOutput(
            reservationId=sandbox.id,
            message='No Static VMs to turn on!'
        )

    # Default Sandbox Setup
    DefaultSetupWorkflow().register(sandbox)
    sandbox.execute_setup()


if __name__ == "__main__":
    main()
