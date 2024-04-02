package Enterprise.SmartWarehouse.TspAlgorithm;


import java.util.*;
import Enterprise.SmartWarehouse.Definitions.*;
import Enterprise.SmartWarehouse.DeliveryTask.Entities.*;
import Enterprise.SmartWarehouse.Order.Entities.OrderHeader.EDeliveryStatus;

//Tsp is stand for travelling salesman problem
public abstract class TspAlgorithm
{
    protected double[][] m_distance;
    protected int[][] m_arr;
    protected int[] m_bestTour;
    protected int m_cityNum;
    protected double m_bestLength;
    protected boolean m_needBack;
    protected boolean m_finish;
    protected boolean m_runByThread;

    protected TaskHeader m_taskInfo;
    protected List<SubTask> m_oriPointList;
    protected List<SubTask> m_updatePointList;

    public final void setOriginalInfo(TaskHeader info, List<SubTask> pointList)
    {
        m_taskInfo = info;
        m_taskInfo.setStatus(EDeliveryStatus.InProgress);
        m_oriPointList = pointList;
        m_cityNum = m_oriPointList.size();
    }

    public final void generateFinalPointList()
    {
        try
        {
            if(m_updatePointList == null)
                m_updatePointList = new ArrayList<>();
            else
                m_updatePointList.clear();
            for (int i = 0; i < m_cityNum; ++i)
            {
                int seq = m_bestTour[i];
                SubTask sub = m_oriPointList.get(seq);
                sub.setSequence(seq);
                System.out.println("subtask id =>"+sub.getOrderId() + ", seq = " + seq);
                sub.setStatus(EDeliveryStatus.InProgress);
                m_updatePointList.add(sub);
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
            System.out.println(e.getMessage());
        }

    }

    public final List<SubTask> getUpdatedPointList()
    {
        return m_updatePointList;
    }
    
    public void startCalculate()
    {
        m_runByThread = false;
        m_finish = false;
        long startTime = System.currentTimeMillis();
        this.run();
        long endTime = System.currentTimeMillis();
        m_finish = true;
        System.out.println("spend time: " + (endTime - startTime));
    }

    public abstract int[] getFullPath();

    public abstract int getTotalLength();
    
    public abstract void run();
}
