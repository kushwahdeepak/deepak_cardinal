import React, { useState, useEffect } from 'react'
import styles from './styles/Table.module.scss'
import { Row, Col, Table } from 'react-bootstrap'
import feather from 'feather-icons'
import ChartContainer from '../ChartContainer/ChartContainer'
import eyeImage from '../../../../../assets/images/icons/eye.png'

function JobsTable({ jobs, userId }) {
  const [viweAnalyticID, setViweAnalyticID] = useState([])
  useEffect(() => {
    feather.replace()
  })
  const handleViweAnalytics = (event, id) => {
    event.stopPropagation()
    viweAnalyticID.push(id)
    setViweAnalyticID([...viweAnalyticID])
  }

  const handleCloseViweAnalitic = (id) => {
    let idList = viweAnalyticID.filter((_id) => _id !== id)
    setViweAnalyticID([...idList])
  }

  const handleAPi = (id,stage) => {
    localStorage.setItem('Stage',stage)
    window.location.href = `/jobs/${id}?stage=${stage}`
  }
  
  return (
    <>
      <div className="table-responsive">
        <table className="table">
          <thead>
            <tr>
              <th className="mt-0">Position</th>
              <th className={styles.borderTopNone}>Leads</th>
              <th className={styles.borderTopNone}>Active Candidates</th>
              <th className={styles.borderTopNone}>Applicants</th>
              <th className={styles.borderTopNone}>Recruiter Screen</th>
              <th className={styles.borderTopNone}>Submitted</th>
              <th className={styles.borderTopNone}>1st Interview</th>
              <th className={styles.borderTopNone}>2nd Interview</th>
              <th className={styles.borderTopNone}>Offers</th>
              <th className={styles.borderTopNone}>Archived</th>
              <th className={styles.borderTopNone}>Metrics</th>
              <th className={styles.borderTopNone}>Expiration Date</th>
            </tr>
          </thead>
          <thead>
            {jobs.map((job) => (
              <>
                <tr>
                  <td className={`${styles.colWidth}`}
                    key={job.id}
                  >
                    <div className={styles.pointer}>
                      <span className={styles.jobName}  onClick={() =>
                      handleAPi(job.id,'lead')
                    }>{job.name}</span>
                      <a href={`/job/previews/${job.id}`} target="_blank" >
                        <img className={`${styles.eyeIcon}`} src={eyeImage} />
                      </a>
                      <br></br>
                      <span className={styles.jobLocation}>
                        {job.location}
                      </span>
                    </div>
                  </td>
                  <td className='text-center'>
                    <a href="#" onClick={() =>
                       handleAPi(job.id,'lead')
                    }>
                      {/* {job && job['metrics'] && job['metrics'][0]['leads'] || 0} */}
                      {job?.metrics && job?.metrics[0]?.leads || 0 }
                    </a>
                  </td>
                  <td className='text-center'>
                    <a href="#" onClick={() => handleAPi(job.id,'active_candidates')
                    }>
                     {job?.metrics && job?.metrics[0]?.active_candidates || 0 }
                    </a>
                  </td>
                  <td className='text-center'>
                    <a href="#" onClick={() => handleAPi(job.id,'applicant')
                    }>
                      {job?.metrics && job?.metrics[0]?.applicant || 0}
                    </a>
                  </td>
                  <td className='text-center'>
                    <a href="#" onClick={() => handleAPi(job.id,'recruitor_screen') 
                    }>
                      {job?.metrics && job?.metrics[0]?.recruiter || 0}
                    </a>
                  </td>
                  <td className={`${styles.minWidth160} text-center`}>
                    <a href="#" onClick={() =>  handleAPi(job.id,'submitted')
                    }>
                      {job?.metrics && job?.metrics[0]?.submitted || 0}
                    </a>
                  </td>
                  <td className={`${styles.minWidth160} text-center`}>
                    <a href="#" onClick={() => handleAPi(job.id,'first_interview')
                    }>
                      {job?.metrics && job?.metrics[0]?.first_interview || 0}
                    </a>
                  </td>
                  <td className={`${styles.minWidth160} text-center`}>
                    <a href="#" onClick={() => handleAPi(job.id,'second_interview')
                    }>
                      {job?.metrics && job?.metrics[0]?.second_interview || 0}
                    </a>
                  </td>
                  <td className='text-center'>
                    <a href="#" onClick={() => handleAPi(job.id,'offer')
                    }>
                      {job?.metrics && job?.metrics[0]?.offer || 0 }
                    </a>
                  </td>
                  <td className='text-center'>
                    <a href="#" onClick={() =>  handleAPi(job.id,'reject')
                    }>
                      {job?.metrics && job?.metrics[0]?.archived || 0}
                    </a>
                  </td>
                  <td  style={{ padding: '3px 1px 3px 5px' }}>
                    <button
                      className={styles.viweAnalitic}
                      style={{
                        marginTop: 10,
                        background: `${
                          viweAnalyticID.includes(job.id)
                            ? '#5263BE'
                            : '#EBEDFA'
                        }`,
                        color: `${
                          !viweAnalyticID.includes(job.id)
                            ? '#5263BE'
                            : '#EBEDFA'
                        }`,
                      }}
                      onClick={(e) => handleViweAnalytics(e, job.id)}
                    >
                      View analytics{' '}
                      <span>
                        <i
                          className={styles.iconArrow}
                          data-feather="chevron-down"
                        ></i>
                      </span>{' '}
                    </button>
                  </td>
                  <td className={styles.expiryDate}>
                    {job.expiry_date?.slice(0, 10) || 0}
                  </td>
              </tr>
                {viweAnalyticID.includes(job.id) && (
                  <tr>
                    <td colspan="10" style={{borderTop:'none'}}>
                      <ChartContainer
                        metricsData={job['metrics'][0]}
                        jobId={job.id}
                        userId={userId}
                        handleCloseViweAnalitic={handleCloseViweAnalitic}
                      />
                    </td>
                  </tr>
                )}
              </>
            ))}
          </thead>
        </table>
      </div>
    </>
  )
}

export default JobsTable
