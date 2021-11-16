module ApplicationHelper
  def page_title(controller_name)
    case controller_name
    when 'reconcile_transactions'
      'Reconciliations'
    when 'dashboard'
      'Home'
    when 'summaries'
      'Summaries'
    end
  end
end
