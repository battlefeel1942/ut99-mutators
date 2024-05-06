class AirstrikeMutator extends Mutator config(User);

var float AirstrikeTimer;
var float AirstrikeInterval;
var bool bAirstrikeIncoming;
var float WarningTime;
var int RocketQuantity;
var float RocketSpeed;
var float SpeedVariation;
var float MaxHorizontalOffset; // Maximum random offset in horizontal direction around the player

function PostBeginPlay()
{
    SetNextAirstrike();
    Super.PostBeginPlay();
}

function SetNextAirstrike()
{
    AirstrikeInterval = FRand() * 15 + 5;
    AirstrikeTimer = 0;
    bAirstrikeIncoming = false;
}

function Tick(float DeltaTime)
{
    local PlayerPawn P;
    local Pawn TempPawn;

    AirstrikeTimer += DeltaTime;

    if (!bAirstrikeIncoming && AirstrikeTimer > AirstrikeInterval - WarningTime)
    {
        bAirstrikeIncoming = true;
        TempPawn = Level.PawnList;
        while (TempPawn != None)
        {
            if (PlayerPawn(TempPawn) != None)
            {
                P = PlayerPawn(TempPawn);
                P.ClientMessage("AIRSTRIKE INCOMING!", 'Event', true);
            }
            TempPawn = TempPawn.NextPawn;
        }
    }

    if (AirstrikeTimer > AirstrikeInterval)
    {
        InitiateAirstrike();
        SetNextAirstrike();
    }

    Super.Tick(DeltaTime);
}

function InitiateAirstrike()
{
    local Vector RocketLocation, PawnLocation, Offset;
    local int i;
    local Rocket SpawnedRocket;
    local Pawn TempPawn;

    TempPawn = Level.PawnList;
    while (TempPawn != None)
    {
        PawnLocation = TempPawn.Location; // Get the location of each pawn

        for (i = 0; i < RocketQuantity; i++) 
        {
            Offset.X = (FRand() - 0.5) * 2 * MaxHorizontalOffset; // Random offset in X direction
            Offset.Y = (FRand() - 0.5) * 2 * MaxHorizontalOffset; // Random offset in Y direction
            Offset.Z = 5000; // Set height for the rocket spawn

            RocketLocation = PawnLocation + Offset; // Add the offset to the pawn's location

            SpawnedRocket = Spawn(class'Rocket', , , RocketLocation);
            if (SpawnedRocket != None)
            {
                SpawnedRocket.Velocity = Vect(0,0,-1) * RocketSpeed; 
                SpawnedRocket.SetRotation(rotator(Vect(0,0,-1))); // Rotate the rocket to face downwards
            }
        }

        TempPawn = TempPawn.NextPawn; // Move to the next pawn in the list
    }
}



defaultproperties
{
    AirstrikeTimer=0.0
    AirstrikeInterval=20.0
    WarningTime=5.0
    RocketQuantity=10
    RocketSpeed=1500
    MaxHorizontalOffset=500.0
}
