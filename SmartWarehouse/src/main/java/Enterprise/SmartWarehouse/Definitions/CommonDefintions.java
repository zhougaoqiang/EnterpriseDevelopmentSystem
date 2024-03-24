package Enterprise.SmartWarehouse.Definitions;

public class CommonDefintions {
    public enum TSPAlgorithmType
    {
        Naive,
        AntColony,
        GreedyNearestVertex
    }
    
    public enum TspDecision
    {
        Auto,
        Quick,
        Best
    }
    
    public enum TaskStatus
    {
        TaskStatus_Created,
        TaskStatus_Caculated,
        TaskStatus_Fetched,
        TaskStatus_Error,
        TaskStatus_Unknown
    }
}
