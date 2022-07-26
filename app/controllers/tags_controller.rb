class TagsController < ApplicationController

  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def create
    begin
      Rails.logger.info("params for create tag: #{params}")
      @tag = Tag.create!(tag_params)
    rescue ActiveRecord::ActiveRecordError => e
      flash[:error] = e.message
      redirect_to new_tag_path
      return
    end
    redirect_to tag_path(@tag)
  end

  def update
    tag = Tag.find(params[:id])
    begin
      tag.update!(tag_params)
    rescue ActiveRecord::ActiveRecordError => e
      flash[:error] = e.message
      redirect_to edit_tag_path(tag)
      return
    end
    redirect_to tag_path(tag)
  end

  def done
    delete
  end

  def delete
    tag = Tag.find(params[:id])
    tag.destroy
    if request.referer
      redirect_to request.referer
    else
      redirect_to tags_path
    end
  end

  def show
    @tag = Tag.where(:id => params['id']).first
  end

  def tag_params
    params.require('tag').permit('title', 'description')
  end
end
