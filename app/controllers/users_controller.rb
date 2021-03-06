class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.valid?
    if !@user.is_email?
      flash[:alert] = "Input a properly formatted email."
      redirect_to :back
    elsif @user.errors.messages[:email] != nil
      flash[:notice]= "That email " + @user.errors.messages[:email].first
      redirect_to :back
    elsif @user.save
      flash[:notice]= "Signup successful. Welcome to the site!"
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      flash[:alert] = "There was a problem creating your account. Please try again."
      redirect_to :back
    end
  end

  def new
  end

  def show
    @users = User.all
    @user = User.find(params[:id])
    
    # Pernw olous tou followers tou
    @my_users = []
    @my_photos = []
    @users.each do |u|
      if @user.following?(u)
        @my_users.push(u)
        @my_photos.push(u.photos) 
      end
    end
    @my_users.push(@user)
    @my_photos.push(@user.photos)
    @final_photos = @my_photos.flatten.sort_by! {|k| k["created_at"]}.reverse!

    # @my_comments = []
    # @final_photos.each do |f|
    #   @my_comments.push(f.comments)
    # end

    Photo.order(created_at: :desc)
    # Pernw oles tis photo
    #@my_photos = Photo.order(created_at: :desc).all
 

    @tag = Tag.new
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :avatar)
  end


end
