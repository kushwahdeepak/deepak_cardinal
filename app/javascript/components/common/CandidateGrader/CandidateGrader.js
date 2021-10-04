import React, { useContext, useState } from 'react'
import isEmpty from 'lodash.isempty'
import { OverlayTrigger, Tooltip } from 'react-bootstrap'
import { StoreDispatchContext } from '../../../stores/JDPStore'
import styles from './styles/CandidateGrader.module.scss'
import { isNil } from 'lodash'
import { makeRequest } from '../RequestAssist/RequestAssist'

function CandidateGrader({ candidate, jobId }) {
    const [requestAssistProps, setRequestAssistProps] = useState({})
    const { dispatch } = useContext(StoreDispatchContext)

    const submitGrade = async (candidate, grade) => {
        const url = '/resume_grades'
        const payload = JSON.stringify({
            resume_grade: {
                job_id: jobId,
                person_id: candidate.id,
                resume_grade: grade,
            },
        })

        await makeRequest(url, 'post', payload, setRequestAssistProps, {})

        dispatch({
            type: 'update_candidate',
            candidate: { ...candidate, resume_grade: grade },
        })
    }

    const getButtonHandler = (grade) => {
        return (e) => {
            e.stopPropagation()
            submitGrade(candidate, grade)
        }
    }

    const alreadyGraded = candidate.resume_grade !== ''

    return (
        <>
            {alreadyGraded && (
                <div className={styles.grader}>
                    <b>Candidate Graded: {candidate.resume_grade - 1}</b>
                </div>
            )}
            {!alreadyGraded && (
                <div className={styles.grader}>
                    <div className={styles.graderTop}>
                        Grade candidate match
                        {
                            !isEmpty(
                                candidate.resume && (
                                    <a href={candidate.resume}>&nbsp;RESUME</a>
                                )
                            )
                        }
                        :
                    </div>
                    <div className={styles.graderBottom}>
                        <OverlayTrigger overlay={<Tooltip>No match</Tooltip>}>
                            <button
                                onClick={getButtonHandler(1)}
                                className={styles.graderChoice}
                            >
                                0
                            </button>
                        </OverlayTrigger>
                        <OverlayTrigger overlay={<Tooltip>Weak match</Tooltip>}>
                            <button
                                onClick={getButtonHandler(2)}
                                className={styles.graderChoice}
                            >
                                1
                            </button>
                        </OverlayTrigger>
                        <OverlayTrigger overlay={<Tooltip>Match</Tooltip>}>
                            <button
                                onClick={getButtonHandler(3)}
                                className={styles.graderChoice}
                            >
                                2
                            </button>
                        </OverlayTrigger>
                        <OverlayTrigger
                            overlay={<Tooltip>Strong match</Tooltip>}
                        >
                            <button
                                onClick={getButtonHandler(4)}
                                className={styles.graderChoice}
                            >
                                3
                            </button>
                        </OverlayTrigger>
                    </div>
                </div>
            )}
        </>
    )
}

export default CandidateGrader
