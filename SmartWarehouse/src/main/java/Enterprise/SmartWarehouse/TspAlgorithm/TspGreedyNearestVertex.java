package Enterprise.SmartWarehouse.TspAlgorithm;

public class TspGreedyNearestVertex extends TspAlgorithm
{
    public TspGreedyNearestVertex(int[][] arr, boolean needBack)
    {
        this.m_arr = arr;
        this.m_needBack = needBack;
        this.m_cityNum = arr.length;
    }

    public void run()
    {
        // init value
        int matrixLen = m_arr.length;
        int sq[] = new int[matrixLen]; // distance
        int flag[] = new int[matrixLen];
        int totalLength = 0;
        for (int i = 0; i < matrixLen; ++i)
        {
            flag[i] = 0;
        }

        if (m_needBack)
            m_bestTour = new int[m_cityNum + 1];
        else
            m_bestTour = new int[m_cityNum];

        m_bestTour[0] = 0;
        int bestTourIndex = 1;
        int start = 0;
        int nextVertex = -1;
        flag[start] = 1;
        while (true)
        {
            sq = m_arr[start];
            int min = Integer.MAX_VALUE;
            for (int i = 0; i < matrixLen; ++i) // get min
            {
                if (min > sq[i] && sq[i] != 0 && flag[i] == 0)
                {
                    min = sq[i];
                    nextVertex = i;
                }
            }

            if (min == Integer.MAX_VALUE)
            {
                if (m_needBack)
                    m_bestTour[bestTourIndex++] = 0;
                break;
            }
            else
            {
                totalLength += m_arr[start][nextVertex];
                flag[nextVertex] = 1;
                m_bestTour[bestTourIndex++] = nextVertex;
                start = nextVertex;
                nextVertex = -1;
            }
        }
        m_bestLength = totalLength;
        
        generateFinalPointList();
    }

    public int[] getFullPath()
    {
        return m_bestTour;
    }

    public int getTotalLength()
    {
        return (int) m_bestLength;
    }
}

