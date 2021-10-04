# Anti-Theft System

Let's understand the problem with the help of a scenario:
In this scenario, the system is initially in the "disarmed" state. Please refer to "Inputs and outputs of the alarm system.jpg" in [Description-And-Informations directory](./Description-And-Informations), where we have illustrated the various inputs and outputs to our alarm system as they might be physically implemented in a typical car. Once the client has turned the ignition off, and exits the car (which is indicated by the driver door being open, then closed), the system begins a countdown of T_ARM_DELAY seconds (e.g. when T_ARM_DELAY = 6, the countdown lasts for 6 seconds). When the countdown is over, the anti-theft system enters its "armed" state The countdown is restarted if the driver door is opened and reclosed before the system has been armed.
Once the system has been armed, opening the driver door or the passenger door begins a countdown. If the ignition is not turned on within the respective countdown interval (T_DRIVER_DELAY and T_PASSENGER_DELAY), the siren sounds. The siren remains on as long as any door is open. After all doors are closed, the alarm remains on for an additional interval T ALARM ON. At this point the system resets to the armed but silent state.
Our unique, additional deterrent involves the power to the fuel pump of the car. (Henceforth we refer to
this subunit as "FuelPumpLogic.") Of course, it is understood that when the fuel pump power is cut, the car will be immobile even if the car's ignition were on. The functional logic of this subunit is as follows: whenever the ignition is turned off, the fuel pump power is turned off regardless of its previous state. When the ignition is on, the driver can turn on the fuel pump power by simultaneously stepping on the brake pedal and by pressing a hidden switch. Note that turning on the car's ignition alone will not restore power to the fuel pump. Rather, one must first turn on the car, and then apply the above sequence of inputs.
It is worthwhile to mention that the additional FuelPumpLogic neutralizes a theft scenario that is not covered by the standard alarm system. Consider the case in which the thief has first stolen the keys to the car. The typical alarm system, in such a case, can be entirely bypassed. However, even if the thief were to possess the key, the car would still be immobile since in all likelihood he will not know the method to restore power to the fuel pump.
In addition, our alarm system provides a status indicator LED which reflects the status of the alarm system(Disarmed, Armed, Triggered, Sound Alarm). Details regarding the specific outputs of the LED are relegated
to the next section.
Finally, all of the timing parameters T_ARM_DELAY, T_DRIVER_DELAY, T_PASSENGER_DELAY and T_ALARM_ON can be reprogrammed to take values between 0 to 15 (seconds). This reprograming feature is not brought out to the client in the car. However, this reprogrammability means that if the client is not satisfied with some of the timing specifications of the system, then he or she may easily consult a technician and have the parameters reconfigured without major adjustments to the system.

A high-level block diagram that illustrates how we have organized the above design into smaller modules is placed in [Description-And-Informations directory](./Description-And-Informations)("Organization of the design into small modules").

Note that we have chosen to implement FuelPumpLogic and AntiTheftFSM using Moore-type finite state machines (FSM).
In examining this diagram, we see an intermediate-level organization that consists of three major units.
They are:
1. FuelPumpLogic;
2. AntiTheftFSM;
3. Programmable one-second timer.

Among the above-mentioned major units, the Programmable one-second timer interacts only with AntiTheftFSM Furthermore, there is only one pattern of interaction. Namely:
1. AntiTheftFSM puts a two-bit value on the 'interval' line that indicates which timing parameter is currently pertinent. In other words, it selects among T_ARM_DELAY, T_DRIVER_DELAY, T_PASSENGER_DELAY and T_ALARM_ON.
2. AntiTheftFSM drives the 'start timer' line high, indicating to the timer subunit that it should begin a countdown towards zero using as the initial value the parameter selected in the previous step. The countdown proceeds at a rate of one decrement per second.
3. Once the timer has reached zero in its countdown, the Programmable one-second timer sends a high on the 'expired' line, indicating to the AntiTheftFSM that the requested amount of time has passed.

You can find the source codes in the [codes directory](./codes).

For more details visit this [link](http://web.mit.edu/6.111/www/s2008/LABS/LAB2/lab2.pdf).
