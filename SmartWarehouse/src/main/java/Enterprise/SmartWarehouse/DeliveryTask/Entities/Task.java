package Enterprise.SmartWarehouse.DeliveryTask.Entities;
import java.util.List;

public class Task {
	private TaskHeader taskHeader;
	private List<SubTask> subTasks;
	public TaskHeader getTaskHeader() {
		return taskHeader;
	}
	public void setTaskHeader(TaskHeader taskHeader) {
		this.taskHeader = taskHeader;
	}
	public List<SubTask> getSubTasks() {
		return subTasks;
	}
	public void setSubTasks(List<SubTask> subTasks) {
		this.subTasks = subTasks;
	}

}
