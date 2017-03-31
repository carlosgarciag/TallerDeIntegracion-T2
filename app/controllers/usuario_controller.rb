class UsuarioController < ApplicationController
  before_action :set_usuario, only: [:show, :update, :destroy]
  skip_before_filter  :verify_authenticity_token
    
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def render_not_found_response(exception)
    render json: { error: 'Usuario no encontrado' }, status: 404
  end

  def index
    @users = Usuario.all.select('id,nombre,apellido,usuario,twitter')
    total = Usuario.all.count
    render json: {usuarios: @users, total: total}, status: 200
  end

  def show
    render json: @user, status: 200
  end

  def update
    
    if @user = Usuario.select('id, nombre, apellido, usuario, twitter').find(params[:id])
      body = JSON.parse request.body.read
      if body["id"]
        render json: { error: 'id no es modificable' }, status: 400
      else
        if body["usuario"]
          @user.usuario = body["usuario"]
        end
        if body["nombre"]
          @user.nombre = body["nombre"]
        end
        if body["apellido"]
          @user.apellido = body["apellido"]
        end
        if body["twitter"]
          @user.twitter = body["twitter"]
        end    
        render json: @user, status: 200
      end
    else
      render json: { error: 'Usuario no encontrado' }, status: 404
    end
  end

  def create
    if(params.has_key?(:id))
      render json: { error: 'No se puede crear usuario con id' }, status: 400
    else
      if(params.has_key?(:usuario)&& params.has_key?(:nombre))
        @newUser = Usuario.new(usuario_params)
        if @newUser.save
          render json: {id: @newUser.id, nombre: @newUser.nombre, apellido: @newUser.apellido, usuario: @newUser.usuario, twitter: @newUser.twitter}, status: 201
        else
            render json: { error: 'La creación ha fallado' }, status: 500
        end
      else
        render json: { error: 'Se requiere usuario y nombre' }, status: 500
      end
    end
  end
  
  def destroy
      if @user.destroy
         head 204
      else
        case status
        when 404
          render json: { error: 'Usuario no encontrado' }, status: 404
        end
      end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usuario
        @user = Usuario.select('id,nombre,apellido,usuario,twitter').find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def usuario_params
      params.permit(:id,:nombre, :apellido, :usuario, :twitter)
    end
    
    def usuario_edit_params
      params.permit(:id, :nombre, :apellido, :usuario, :twitter)
    end
end
