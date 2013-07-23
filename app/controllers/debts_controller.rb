# encoding: utf-8
class DebtsController < ApplicationController
  # GET /debts
  # GET /debts.json
  before_filter :require_login

  def index
    @debts = Debt.unpaid.where("debtor_id = ?", current_user.id)
    @credits = Debt.unpaid.where("creditor_id = ?", current_user.id)
    @old_debts = Debt.paid.where("debtor_id = ?", current_user.id)
    @old_credits = Debt.paid.where("creditor_id = ?", current_user.id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @debts }
    end
  end

  # GET /debts/1
  # GET /debts/1.json
  def show
    @debt = Debt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @debt }
    end
  end

  # GET /debts/new
  # GET /debts/new.json
  def new
    @debt = Debt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @debt }
    end
  end

  # GET /debts/1/edit
  def edit
    @debt = Debt.find(params[:id])
  end

  # POST /debts
  # POST /debts.json
  def create
    @debt = Debt.new(params[:debt])
    respond_to do |format|
      if @debt.save
        format.html { redirect_to @debt, notice: 'La dette a bien été créer' }
        format.json { render json: @debt, status: :created, location: @debt }
      else
        format.html { render action: "new" }
        format.json { render json: @debt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /debts/1
  # PUT /debts/1.json
  def update
    @debt = Debt.find(params[:id])

    respond_to do |format|
      if @debt.update_attributes(params[:debt])
        format.html { redirect_to @debt, notice: 'La dette a bien été mise à jour.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @debt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /debts/1
  # DELETE /debts/1.json
  def destroy
    @debt = Debt.find(params[:id])
    @debt.destroy

    respond_to do |format|
      format.html { redirect_to debts_url }
      format.json { head :no_content }
    end
  end

  # PUT /debts/1
  # PUT /debts/1.json
  def solve
    @debt = Debt.find(params[:id])
    respond_to do |format|
      if @debt.update_attributes(:is_paid=>true)
        format.html { redirect_to @debt, notice: 'La dette a bien été mise à jour.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @debt.errors, status: :unprocessable_entity }
      end
    end
  end

end
