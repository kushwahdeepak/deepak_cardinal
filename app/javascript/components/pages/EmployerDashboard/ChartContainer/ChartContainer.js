import React, { useState, useEffect } from 'react'
import feather from 'feather-icons'
import moment from 'moment'
import { Row, ButtonGroup } from 'react-bootstrap'
import { Alert, Spinner } from 'react-bootstrap'

import DateRangePicker from '../../../common/DateRangePicker/DateRangePicker'
import { BarChart, LineChart } from '../../../common/Chart'
import useCustomFetch from '../../../hooks/useCustomFetch'
import styles from './styles/ChartContainer.module.scss'

import { Legends, getBarChartData } from './constants'

function ChartContainer({
  metricsData,
  handleCloseViweAnalitic,
  jobId,
  userId,
}) {
  const [isEngagementGraph, setIsEngagementGraph] = useState(true)
  const [filter, setFilter] = useState({ startDate: Date(), endDate: Date() })
  const startDate = moment(filter.startDate).format('MM/DD/YYYY')
  const endDate = moment(filter.endDate).format('MM/DD/YYYY')

  const URL = `/employer_home.json?page=${1}&user_id=${userId}&job_id=${jobId}&start_date=${startDate}&end_date=${endDate}`

  const [
    data,
    loading,
    errorFetchingJob,
    setErrorFetchingJob,
  ] = useCustomFetch(URL)

  useEffect(() => {
    feather.replace()
  })

  const handleEngagementGraph = () => {
    setIsEngagementGraph(true)
  }
  const handleMatricGraph = () => {
    setIsEngagementGraph(false)
  }
  const handleOnSubmit = (newDate) => {
    setFilter(newDate)
  }
  function buildBarData() {
    const chartData = getBarChartData()
    if (!data || data?.jobs?.length < 0) {
        return chartData
    }

    const metrics = [metricsData] || []

    const results = chartData.map((item) => {
      if (item.name === 'Leads') {
          item.count = metrics[0] && metrics[0].leads
      }

      if (item.name === 'Active Candidates') {
        item.count = metrics[0] && metrics[0].archive
      }

      if (item.name === 'Applicants') {
          item.count = metrics[0] && metrics[0].applicant
      }

      if (item.name === 'Recruiter screen') {
          item.count = metrics[0] && metrics[0].recruiter
      }

      if (item.name === 'Submitted') {
          item.count = metrics[0] && metrics[0].submitted
      }

      if (item.name === '1st Interview') {
          item.count = metrics[0] && metrics[0].first_interview
      }

      if (item.name === '2nd Interview') {
          item.count = metrics[0] && metrics[0].second_interview
      }

      if (item.name === 'Offers') {
          item.count = metrics[0] && metrics[0].offer
      }

      if (item.name === 'Archived') {
          item.count = metrics[0] && metrics[0].archived
      }

      return item
  })

    return results
  }

  function buildLineChartData() {
    if (!data || data?.jobs?.length < 0) {
      return []
    }

    const metrics = data?.jobs[0]?.metrics || []
    const lineChartData = metrics.map((item) => {
      return {
          ...item,
          date: moment(item.metrics_date).format('MMM DD'),
      }
    })
    return [...lineChartData]
  }

    return (
      <>
        <Row className={styles.rowChartContainer + ' d-flex mt-3'}>
          <div className={styles.chartContainer}>
                <Row className={styles.chartHeader}>
                    <ButtonGroup style={{ display: 'initial' }}>
                        <button
                            style={{
                                background: `${
                                    isEngagementGraph
                                        ? '#4C68FF'
                                        : ' #EBEDFA'
                                }`,
                                color: `${
                                    isEngagementGraph
                                        ? ' #EBEDFA'
                                        : '#4C68FF'
                                }`,
                            }}
                            className={styles.graphButton}
                            onClick={() => handleEngagementGraph()}
                        >
                            {' '}
                            Engagement Graph
                        </button>
                        <button
                            style={{
                                background: `${
                                    !isEngagementGraph
                                        ? '#4C68FF'
                                        : ' #EBEDFA'
                                }`,
                                color: `${
                                    !isEngagementGraph
                                        ? ' #EBEDFA'
                                        : '#4C68FF'
                                }`,
                            }}
                            className={styles.graphButton}
                            onClick={() => handleMatricGraph()}
                        >
                            {' '}
                            Metric Bar{' '}
                        </button>
                    </ButtonGroup>
                    <div className={styles.clanederContainer}>
                        {' '}
                        {isEngagementGraph && (
                            <DateRangePicker
                                defaultDate={filter}
                                handleOnSubmit={handleOnSubmit}
                            />
                        )}
                    </div>
                    <div style={{ flexGrow: 1 }}></div>
                    <div
                        onClick={() => handleCloseViweAnalitic(jobId)}
                        className={styles.close}
                    >
                        Close{' '}
                        <span>
                            <i
                                className={styles.exitIcon}
                                data-feather="x"
                            ></i>
                        </span>
                    </div>
                </Row>
                <Row
                    style={{ margin: '0px !important' }}
                    className={styles.graphNameRow}
                >
                  <span className={styles.graphName}>
                    {!isEngagementGraph
                        ? 'Metric Bar'
                        : 'Engagement Graph'}
                  </span>
                </Row>
                  {loading ? (
                    <div className="d-flex justify-content-center">
                      <Spinner animation="border" role="status">
                        <span className="sr-only">Loading...</span>
                      </Spinner>
                    </div>
                  ) : errorFetchingJob ? (
                      <Alert
                        variant="danger"
                        onClose={() => setErrorFetchingJob(null)}
                        dismissible
                        className="mt-4"
                      >
                        {errorFetchingJob}
                      </Alert>
                  ) : (
                      <Row className={styles.graphsContainer}>
                        {isEngagementGraph ? (
                          <LineChart
                            data={buildLineChartData()}
                            legends={Legends}
                          />
                        ) : (
                          <BarChart data={buildBarData()} />
                        )}
                      </Row>
                  )}
          </div>
        </Row>
      </>
    )
}

export default ChartContainer
