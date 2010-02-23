# -*- coding: utf-8 -*-
class Notification < ActionMailer::Base

  # Уведомление о завершение задачи
  def completed_task(task)
    subject     "Hydra: Task ##{task.id} completed."
    from        ActionMailer::Base.smtp_settings[:user_name]
    recipients  task.user.email
    sent_on     Time.now
    body        :task => task
  end

  # Уведомление о завершение задачи с ошибкой
  def stopped_task(task)
    subject     "Hydra: Task ##{task.id} stopped(error)."
    from        ActionMailer::Base.smtp_settings[:user_name]
    recipients  task.user.email
    sent_on     Time.now
    body        :task => task
  end

end

