class Api::TodoListsController < Api::ApiController
	def index
		Rails.logger.info "Current user: #{current_user.inspect}"
    render json: { todo_lists: current_user.todo_lists }
  end

	def show
		list = current_user.todo_lists.find(params[:id])
		render json: list.as_json(include:[:todo_items])
	end

	def create
		list = current_user.todo_lists.new(list_params)
		if list.save
			render status: 200, json: {
				message: "Successfully created To-do List.",
				todo_list: list
			}.to_json
		else
			render status: 422, json: {
				errors: list.errors
			}.to_json
		end
	end

	def update
		list = current_user.todo_lists.find(params[:id])
		if list.update(list_params)
			render status: 200, json: {
				message: "Successfully updated",
				todo_list: list
			}.to_json
		else
			render status: 422, json: {
				message: "The To-do List could not be updated",
				todo_list: list
			}.to_json
		end
	end

	def destroy
		list = current_user.todo_lists.find(params[:id])
		list.destroy
		render status: 200, json: {
			message: "Succsessfully deleted To-do List."
		}.to_json
	end

	private

	def list_params
		params.require("todo_list").permit("title")
	end
end
