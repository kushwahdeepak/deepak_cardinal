import CompanyPlaceholderImage from '../../../assets/images/talent_page_assets/company-placeholder.png'

/**
 * convert string date into descriptive date formate
 * example: "2021-01-01" to Monday, 1 January 2021
 */

function formatDate(dateStr){
  return new Date(dateStr).toDateString()
}

function formatStage(stage) {
  let stages = {
    'active_candidates': 'Active Candidates',
  	'recruitor_screen': 'Recruiter screen',
    'submitted': 'Submitted',
    'first_interview': '1st interview',
    'second_interview': '2nd interview',
    'applicant': 'Applicants',
    'offers': 'Offers',
    'archive': 'Archive'

  }
  return stages[stage]
}

function formatTime(time_hash) {
  let {hour, minute, isAM, timeZone} = time_hash
  return hour+':'+minute+' '+isAM+' '+timeZone
}

function interviewStageTime(str) {
  const time_arr = parseStr(str)
  const time = time_arr[0]
  const {hour, minute, isAM, timeZone} = time
  return hour+':'+minute+' '+isAM+' '+timeZone
}

function parseStr(str) {
  return JSON.parse(str)
}

function getStageFromTimeHash(str) {
  const time_arr = parseStr(str)
  const time = time_arr[0]
  const stage = formatStage(time.stage)
  return stage
}

function getPrimaryInterviewer(str) {
  const interviewers = parseStr(str)
  let primary_interviewer = {}
  if(interviewers.length > 0) {
  	primary_interviewer = interviewers[0]
  	return primary_interviewer['name']
  }
  return ''
}

function getAdditionalInterviewer(str) {
  const interviewers = parseStr(str)
  let additional_interviewer = {}

  if(interviewers.length > 1) {
  	additional_interviewer = interviewers[1]
  	return additional_interviewer['name']
  }
  return ''
}

function getAllInterviewers(str) {
  const interviewers = parseStr(str)
  let all_interviewers = {}

  all_interviewers = interviewers.map((interviewer => {
    return(interviewer)
  }))
  return ''
}

// interview schedule edit tooltip helpers
// function getAllInterviewers(str) {
//   const interviewers = parseStr(str)
//   return interviewers.map(i => (i.name)).join(',')
// }

function getAllTimeStage(str) {
  const time = parseStr(str)
  return time.map((t) => {
  	return [
  	  { key: 'Time', value: formatTime(t), icon: 'clock' },
  	  { key: 'Stage', value: formatStage(t.stage), icon: 'file-text' }
  	]
  }).flat()
}

// handel broken image url
const handelBrokenUrl = (event) => {
  if(event.target.naturalHeight == 0)
    event.target.src = CompanyPlaceholderImage
}

export { 
  formatDate, formatStage, getStageFromTimeHash, interviewStageTime,
  getPrimaryInterviewer, getAdditionalInterviewer, getAllInterviewers,
  getAllTimeStage, handelBrokenUrl
}