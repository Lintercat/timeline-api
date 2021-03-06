defmodule TimelineWeb.TaskController do
  use TimelineWeb, :controller

  alias Timeline.Work
  alias Timeline.Work.Task

  action_fallback TimelineWeb.FallbackController

  def index(conn, _params) do
    tasks = Work.list_tasks()
    render(conn, "index.json-api", data: tasks)
  end

  def running(conn, _params) do
    task = Work.running_task()
    render(conn, "show.json-api", data: task)
  end

  def create(conn, %{"task" => task_params}) do
    with {:ok, %Task{} = task} <- Work.create_task(task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", task_path(conn, :show, task))
      |> render("show.json-api", data: task)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Work.get_task!(id)
    render(conn, "show.json-api", data: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Work.get_task!(id)

    with {:ok, %Task{} = task} <- Work.update_task(task, task_params) do
      render(conn, "show.json-api", data: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Work.get_task!(id)
    with {:ok, %Task{}} <- Work.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end

  def stop(conn, %{"id" => id}) do
    task = Work.get_task!(id)

    with {:ok, %Task{} = task} <- Work.stop_task(task) do
      render(conn, "show.json-api", data: task)
    end
  end
end
