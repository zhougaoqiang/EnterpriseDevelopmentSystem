package Enterprise.SmartWarehouse.TspAlgorithm;

import java.util.*;

public class TspNaive extends TspAlgorithm
{

    public TspNaive(int[][] arr, boolean needBack)
    {
        this.m_arr = arr;
        this.m_needBack = needBack;
        this.m_cityNum = arr.length;
    }

    public void run()
    {
        if (m_arr.length > 10)
            return;

        int matrixLen = m_arr.length;
        int cases = 1;
        for (int i = matrixLen - 1; i > 1; --i)
            cases = cases * i;
        System.out.printf("get toatl number of cases %d \n", cases);

//    	int allcases[] = getAllCases(matrixLen, cases);
//    	int allLengths[] = new int[cases];
//    	for (int i = 0; i < cases; ++i)
//    	{
//    		int perCase = allcases[i];
//    		
//    		String str = "0" + String.valueOf(perCase);
//    		if (needBack)
//    			str = str + "0";
//    		char cArr[] = str.toCharArray();
//    		int len = cArr.length;
//    		allLengths[i] = 0;
//    		for(int j = 0; j < len - 1; ++j)
//    		{
//    			int c1 = Character.getNumericValue(cArr[j]);
//    			int c2 = Character.getNumericValue(cArr[j + 1]);
//    			allLengths[i] += arr[c1][c2];
//    		}
//    	}
//    	int minLen = allLengths[0];
//    	int minLenCase = allcases[0];
//    	for (int i = 1 ; i < cases; ++i)
//    	{
//    		if(minLen > allLengths[i])
//    		{
//    			minLen = allLengths[i];
//    			System.out.println("get length:  " + minLen);
//    			minLenCase = allcases[i];
//    		}
//    	}
//    	String str = String.valueOf(minLenCase);
//    	System.out.println("get best way: " + str);

        generateAllCases();
        int allLengths[] = new int[cases];
        for (int i = 0; i < cases; ++i)
        {
            String str = "0" + allCasesString.get(i);
            if (m_needBack)
                str = str + "0";
            char cArr[] = str.toCharArray();
            int len = cArr.length;
            allLengths[i] = 0;
            for (int j = 0; j < len - 1; ++j)
            {
                int c1 = Character.getNumericValue(cArr[j]);
                int c2 = Character.getNumericValue(cArr[j + 1]);
                allLengths[i] += m_arr[c1][c2];
            }
        }

        int minLen = allLengths[0];
        String minLenCase = allCasesString.get(0);
        for (int i = 1; i < cases; ++i)
        {
            if (minLen > allLengths[i])
            {
                minLen = allLengths[i];
//    			System.out.println("get length:  " + minLen);
                minLenCase = allCasesString.get(i);
            }
        }

        m_bestLength = (double) minLen;
        System.out.println("get final path:  " + minLenCase);
        char cArr[] = minLenCase.toCharArray();
        if (m_needBack)
            m_bestTour = new int[cArr.length + 1];
        else
            m_bestTour = new int[cArr.length];

        for (int i = 0; i < cArr.length; ++i)
            m_bestTour[i] = Character.getNumericValue(cArr[i]);

        if (m_needBack)
            m_bestTour[cArr.length] = 0;

//     	if(needBack)
//    		bestTour = new int[cArr.length + 2];
//    	else
//    		bestTour = new int[cArr.length + 1];
//    	
//    	bestTour[0] = 0;
//    	for(int i = 1; i <= cArr.length; ++i)
//    		bestTour[i] = Character.getNumericValue(cArr[i - 1]);
        
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

    @SuppressWarnings("unused")
	private int[] getAllCases(int matrixLen, int cases)
    {
        int firstCase = 123456789;
        if (matrixLen < 10)
        {
            int pre = 10;
            for (int i = 1; i < 10 - matrixLen; ++i)
                pre = pre * 10;
            firstCase = firstCase / pre;
        }
        System.out.printf("get first case %d \n", firstCase);

        int lastCase = 987654321;
        int las = 10;
        for (int i = 1; i < matrixLen - 1; ++i)
            las = las * 10;
        lastCase = lastCase % las;
        System.out.printf("get last case %d \n", lastCase);

        int val = firstCase;
        int index = 0;
        int allCases[] = new int[cases];
        String str = String.valueOf(firstCase);
        System.out.printf("get check String %s \n", str);
        while (val <= lastCase)
        {
            if (isBadSequence(val, str))
            {
                ++val;
                continue;
            }

            allCases[index++] = val;
            ++val;
        }

        return allCases;
    }

    private boolean isBadSequence(int num, String ori)
    {
        String str = String.valueOf(num);
        char[] elements = str.toCharArray();
        for (char e : elements)
        {
            if (ori.indexOf(e) < 0)
            {
                return true;
            }

            if (str.indexOf(e) != str.lastIndexOf(e))
            {
                return true;
            }
        }
        return false;
    }

    /* a better way to get full cases, but not necessary; */
    private List<String> allCasesString;

    private void generateAllCases()
    {
        allCasesString = new ArrayList<>();
        List<Integer> sl = new ArrayList<>();
        for (int i = 0; i < m_cityNum; ++i)
        {
            sl.add(i);
        }

        DFS(sl, "");
    }

    private void DFS(List<Integer> candidate, String prefix)
    {
        if (prefix.length() != 0 && candidate.size() == 0)
        {
            allCasesString.add(prefix);
        }

        for (int i = 0; i < candidate.size(); i++)
        {
            List<Integer> temp = new LinkedList<Integer>(candidate);
            int item = (int) temp.remove(i);
            DFS(temp, prefix + item);
        }
    }
}
