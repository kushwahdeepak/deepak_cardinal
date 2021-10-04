class TopCandidatesMailer < ApplicationMailer
  default from: "noreply@cardinaltalent.ai"

  def csv_email(csv)
    attachments['top_candidates.csv'] = {mime_type: 'text/csv', content: csv}
    mail(
      to: ["donjuanin@gmail.com", "paul@paulchristophercampbell.com", "lawrence@lawrencewang.com", "cantnotbelieve@gmail.com"],
      subject: "Top 20 percents candidates that have applied to jobs in last week.",
    )
  end
end
