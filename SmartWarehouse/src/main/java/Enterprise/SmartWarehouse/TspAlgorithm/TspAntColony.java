package Enterprise.SmartWarehouse.TspAlgorithm;

import java.util.Random;

public class TspAntColony extends TspAlgorithm {
	private double[][] m_pheromone;
	private int m_antNum;
	private int m_maxGen;
	private double m_alpha; // a factor
	private double m_beta; // b factor
	private double m_rho; // pheromone volatile factor
	private double m_q; // constant number?

	public TspAntColony(int[][] arr, boolean needBack) {
		this.m_cityNum = arr.length;
		m_distance = new double[m_cityNum][m_cityNum];
		for (int i = 0; i < m_cityNum; ++i) {
			for (int j = 0; j < m_cityNum; ++j)
				m_distance[i][j] = (double) arr[i][j];
		}
		if (this.m_cityNum > 20) {
			this.m_antNum = this.m_cityNum * 5;
			this.m_maxGen = this.m_antNum * 5;
		} else {
			this.m_antNum = this.m_cityNum * 10;
			this.m_maxGen = this.m_antNum * 10;
		}
		this.m_alpha = 1.0;
		this.m_beta = 5.0;
		this.m_rho = 0.9; // 0.5
		this.m_q = 1;
		this.m_pheromone = new double[m_cityNum][m_cityNum];
		this.m_bestTour = new int[m_cityNum];
		this.m_bestLength = Double.MAX_VALUE;
		this.m_needBack = needBack;
	}

	public TspAntColony(double[][] distance, int antNum, int maxGen, double alpha, double beta, double rho, double q,
			boolean needBack) {
		this.m_distance = distance;
		this.m_cityNum = distance.length;
		this.m_antNum = antNum;
		this.m_maxGen = maxGen;
		this.m_alpha = alpha;
		this.m_beta = beta;
		this.m_rho = rho;
		this.m_q = q;
		this.m_pheromone = new double[m_cityNum][m_cityNum];
		this.m_bestTour = new int[m_cityNum];
		this.m_bestLength = Double.MAX_VALUE;
		this.m_needBack = needBack;
	}

	private void initPheromone() {
		double initPheromone = 1.0 / (m_cityNum * m_distance[0][1]);
		for (int i = 0; i < m_cityNum; i++) {
			for (int j = 0; j < m_cityNum; j++) {
				m_pheromone[i][j] = initPheromone;
			}
		}
	}

	private int[] antMove(double[][] pheromone) {
		int[] tour = new int[m_cityNum];
		boolean[] visited = new boolean[m_cityNum];
		Random random = new Random();
		int start;
		start = m_needBack ? random.nextInt(m_cityNum) : 0;
		visited[start] = true;
		tour[0] = start;
		for (int i = 1; i < m_cityNum; i++) {
			int curCity = tour[i - 1];
			double[] p = new double[m_cityNum];
			double sum = 0.0;
			for (int j = 0; j < m_cityNum; j++) {
				if (!visited[j]) {
					p[j] = Math.pow(pheromone[curCity][j], m_alpha) * Math.pow(1.0 / m_distance[curCity][j], m_beta);
					sum += p[j];
				}
			}

			double rand = random.nextDouble();
			double tmp = 0.0;
			int nextCity = 0;
			for (int j = 0; j < m_cityNum; j++) {
				if (!visited[j]) {
					tmp += p[j] / sum;
					if (tmp >= rand) {
						nextCity = j;
						break;
					}
				}
			}
			visited[nextCity] = true;
			tour[i] = nextCity;
		}
		return tour;
	}

	private void updatePheromone() {
		double[][] deltaPheromone = new double[m_cityNum][m_cityNum];
		for (int i = 0; i < m_antNum; i++) {
			int[] tour = antMove(m_pheromone);
			double tourLength = getTourLength(tour);
			if (tourLength < m_bestLength) {
				m_bestLength = tourLength;
				System.arraycopy(tour, 0, m_bestTour, 0, m_cityNum);
			}
			for (int j = 0; j < m_cityNum - 1; j++) {
				int city1 = tour[j];
				int city2 = tour[j + 1];
				deltaPheromone[city1][city2] += m_q / tourLength;
				deltaPheromone[city2][city1] = deltaPheromone[city1][city2];
			}
			deltaPheromone[tour[m_cityNum - 1]][tour[0]] += m_q / tourLength;
			deltaPheromone[tour[0]][tour[m_cityNum - 1]] = deltaPheromone[tour[m_cityNum - 1]][tour[0]];
		}
		for (int i = 0; i < m_cityNum; i++) {
			for (int j = 0; j < m_cityNum; j++) {
				m_pheromone[i][j] = m_pheromone[i][j] * (1.0 - m_rho) + deltaPheromone[i][j];
			}
		}
	}

	private double getTourLength(int[] tour) {
		double tourLength = 0.0;
		for (int i = 0; i < m_cityNum - 1; i++) {
			tourLength += m_distance[tour[i]][tour[i + 1]];
		}
		if (m_needBack)
			tourLength += m_distance[tour[m_cityNum - 1]][tour[0]];

		return tourLength;
	}

	public void run() {
		initPheromone();
		for (int i = 0; i < m_maxGen; i++) {
			updatePheromone();
		}

		generateFinalPointList();
//        System.out.println("迭代" + m_maxGen + "次后，最优的路径长度：" + m_bestLength);
//        System.out.print("最优路径为：");
//        for (int i = 0; i < m_cityNum; i++)
//        {
//            System.out.print(m_bestTour[i] + " ");
//        }
//        System.out.println();
	}

	public int[] getFullPath() {
		if (!m_needBack)
			return m_bestTour;

		int pos = 0;
		for (; pos < m_cityNum; ++pos) {
			if (m_bestTour[pos] == 0)
				break;
		}

		int[] rtn = new int[m_cityNum + 1];
		int j = 0;
		for (int i = pos; i < m_cityNum; ++i)
			rtn[j++] = m_bestTour[i];

		for (int i = 0; i < pos; ++i)
			rtn[j++] = m_bestTour[i];

// 		rtn[cityNum] = 0;
		return rtn;
	}

	public int getTotalLength() {
		return (int) m_bestLength;
	}
}
