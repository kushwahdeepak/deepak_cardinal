import React, { useState, useEffect } from 'react'
import styles from './styles/Table.module.scss'
import { Row, Col } from 'react-bootstrap'
import feather from 'feather-icons'
import ChartContainer from '../ChartContainer/ChartContainer'

function Table({ jobs, userId }) {
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

    return (
      <>
        <Row
            className={
              styles.tableHeadingText + ' d-flex align-items-center mt-3'
            }
        >
          <Col xs={2} className="d-flex align-items-start">
              <span style={{ marginLeft: '18px' }}>Position</span>
          </Col>
          <Col className={`${styles.jobsPadding}`} xs={1}>
              <span>Leads</span>
          </Col>
          <Col className={`${styles.jobsPadding}`} xs={1}>
              <span>Active Candidates</span>
          </Col>
          <Col className={`${styles.jobsPadding}`} xs={1}>
              <span>Applicants</span>
          </Col>
          <Col className={`${styles.jobsPadding}`} xs={1}>
              <span>Recruiter Screen</span>
          </Col>
          <Col className={`${styles.jobsPadding}`} xs={1}>
              <span>Submitted</span>
          </Col>
          <Col className={`${styles.jobsPadding}`} xs={1}>
              <span>1st Interview</span>
          </Col>
          <Col className={`${styles.jobsPadding}`} xs={1}>
              <span>2nd Interview</span>
          </Col>
          <Col className={`${styles.jobsPadding}`} xs={1}>
              <span>Offers</span>
          </Col>
          <Col className={`${styles.jobsPadding}`} xs={1}>
              <span>Archived</span>
          </Col>
          <Col className={`${styles.jobsPadding}`} xs={1}>
              <span>Metrics</span>
          </Col>
          <Col xs={1}>
              <span>Creation Date</span>
          </Col>
        </Row>
        {jobs.map((job) => (
          <React.Fragment key={job.id}>
            <Row
                className={`${styles.tableHeadingText} ${styles.tableRow} d-flex align-items-center`}
            >
              <Col
                  xs={2}
                  className="d-flex flex-column align-items-start text-left"
              >
                  <span className={styles.jobName} onClick={() =>
                    (window.location.href = `/jobs/${job.id}`)
                  }>{job.name}</span>
                  <a href={`/job/previews/${job.id}`} target="_blank" >
                    <img className={`${styles.eyeIcon}`} src={eyeImage} />
                  </a>
                  <span className={styles.jobLocation}>
                      {job.location}
                  </span>
              </Col>
              <Col xs={1}>
                  <a href="#" onClick={() =>
                    (window.location.href = `/jobs/${job.id}?stage=lead`)
                  }>
                    {job['metrics'][0]['leads_count'] || 0}
                  </a>
              </Col>
              <Col xs={1}>
                  <a href="#" onClick={() =>
                    (window.location.href = `/jobs/${job.id}?stage=lead`)
                  }>
                    {job['metrics'][0]['archive_count'] || 0}
                  </a>
              </Col>
              <Col xs={1}>
                  <a href="#" onClick={() =>
                    (window.location.href = `/jobs/${job.id}?stage=applicant`)
                  }>
                    {job['metrics'][0]['applicants_count'] || 0}
                  </a>
              </Col>
              <Col xs={1}>
                  <a href="#" onClick={() =>
                    (window.location.href = `/jobs/${job.id}?stage=recruitor_screen`)
                  }>
                    {job['metrics'][0]['recruiter_screen'] || 0}
                  </a>
              </Col>
              <Col xs={1}>
                  <a href="#" onClick={() =>
                    (window.location.href = `/jobs/${job.id}?stage=submitted`)
                  }>
                    {job['metrics'][0]['submitted'] || 0}
                  </a>
              </Col>
              <Col xs={1}>
                  <a href="#" onClick={() =>
                    (window.location.href = `/jobs/${job.id}?stage=first_interview`)
                  }>
                    {job['metrics'][0]['first_interview_count'] || 0}
                  </a>
              </Col>
              <Col xs={1}>
                  <a href="#" onClick={() =>
                    (window.location.href = `/jobs/${job.id}?stage=second_interview`)
                  }>
                    {job['metrics'][0]['second_interview_count'] || 0}
                  </a>
              </Col>
              <Col xs={1}>
                  <a href="#" onClick={() =>
                    (window.location.href = `/jobs/${job.id}?stage=offer`)
                  }>
                    {job['metrics'][0]['offers_count'] || 0}
                  </a>
              </Col>
              <Col xs={1}>
                  <a href="#" onClick={() =>
                    (window.location.href = `/jobs/${job.id}?stage=reject`)
                  }>
                    {job['metrics'][0]['archive_count'] || 0}
                  </a>
              </Col>
              <Col xs={1} style={{ padding: '3px 1px 3px 5px' }}>
                <button
                  className={styles.viweAnalitic}
                  style={{
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
              </Col>
              <Col xs={1}>
                <span>
                  {job.created_at.slice(0, 10) || 0}
                </span>
              </Col>
            </Row>
              {viweAnalyticID.includes(job.id) && (
                <ChartContainer
                  metricsData={job['metrics'][0]}
                  jobId={job.id}
                  userId={userId}
                  handleCloseViweAnalitic={handleCloseViweAnalitic}
                />
              )}
            </React.Fragment>
        ))}
      </>
    )
}

export default Table
