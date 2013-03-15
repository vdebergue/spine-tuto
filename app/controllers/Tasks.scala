package controllers

import play.api._
import play.api.mvc._
import play.api.libs.json._
import play.api.libs.functional.syntax._

object Tasks extends Controller {

  case class Task(id: String, name: String, done: Option[Boolean])
  implicit val taskWrites = Json.format[Task]

  // naive collection
  val taskCollection = collection.mutable.Map[String, Task](
    ("1" -> Task("1", "Awesome Thing", Some(true)))
  )
  var count = 1

  def index = Action {
    println("get")
    Ok(Json.toJson(taskCollection.values))
  }

  def post = Action { request =>
    println("post")
    request.body.asJson.map { json =>
      json.validate[Task].map {
        case t: Task => {
          count +=1
          val newTask = t.copy(id = count + "")
          taskCollection += (count + "" -> newTask)
          Ok(Json.toJson(newTask))
        }
      }.recoverTotal{
        e => BadRequest("Detected error: "+ JsError.toFlatJson(e))
      }
    }.getOrElse {
      BadRequest("Expecting Json data")
    }
  }

  def update(id: String) = Action { request =>
    println("put")
    request.body.asJson.map { json =>
      json.validate[Task].map {
        case t: Task => {
          taskCollection update (t.id, t)
          Ok(Json.toJson(t))
        }
      }.recoverTotal{
        e => BadRequest("Detected error: "+ JsError.toFlatJson(e))
      }
    }.getOrElse {
      BadRequest("Expecting Json data")
    }
  }

  def delete(id: String) = Action {
    println("delete")
    taskCollection -= id
    Ok("Done")
  }
}