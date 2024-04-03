package Enterprise.SmartWarehouse.TspAlgorithm;

public class TspCombination extends TspAlgorithm {
	public class TspResult {
		public TspResult(int v[], int l) {
			m_path = v;
			m_length = l;
		}

		public int m_path[];
		public int m_length;

		public static void showResult(int path[], int length) {
			System.out.print("get path => ");
			for (int i = 0; i < path.length; ++i) {
				if (i == path.length - 1) {
					System.out.print(path[i]);
					break;
				}
				System.out.print(path[i] + "->");
			}

			System.out.println();
			System.out.println("get total lenth = " + length);
		}
	}

	public TspCombination(int[][] arr, boolean needBack) {
		this.m_arr = arr;
		this.m_needBack = needBack;
		this.m_cityNum = arr.length;
	}

	@Override
	public int[] getFullPath() {
		// TODO Auto-generated method stub
		return m_bestTour;
	}

	@Override
	public int getTotalLength() {
		// TODO Auto-generated method stub
		return (int) m_bestLength;
	}

	public void run() {
		TspAlgorithm a1 = new TspAntColony(m_arr, m_needBack);
		a1.run();

		TspAlgorithm alAnt = new TspAntColony(m_arr, m_needBack);
		alAnt.startCalculate();
		int pathAnt[] = alAnt.getFullPath();
		int lengthAnt = alAnt.getTotalLength();
		TspResult.showResult(pathAnt, lengthAnt);
		TspAlgorithm alGreedy = new TspGreedyNearestVertex(m_arr, m_needBack);
		alGreedy.startCalculate();
		int pathGreedy[] = alGreedy.getFullPath();
		int lengthGreedy = alGreedy.getTotalLength();
		TspResult.showResult(pathGreedy, lengthGreedy);

		if (lengthAnt < lengthGreedy) {
			this.m_bestTour = pathAnt;
			this.m_bestLength = lengthAnt;
		} else {
			this.m_bestTour = pathGreedy;
			this.m_bestLength = lengthGreedy;
		}

		generateFinalPointList();
	}

}
