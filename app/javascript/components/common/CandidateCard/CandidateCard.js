import React, { useContext } from 'react'
import Form from 'react-bootstrap/Form'
import { CircularProgressbarWithChildren } from 'react-circular-progressbar'
import moment from 'moment'
import isEmpty from 'lodash.isempty'
import { capitalizeFirstLetter } from '../../../utils'
import 'react-circular-progressbar/dist/styles.css'
import './styles/CandidateCard.scss'
import { StoreDispatchContext } from '../../../stores/JDPStore'

const CandidateCard = (props) => {
    const { candidate, clickHandler, idx } = props

    const { state, dispatch } = useContext(StoreDispatchContext)
    const checked = state.selectedCandidates[idx] ? true : false

    const handleCheckboxChange = (event) => {
        dispatch({
            type: 'toggle_candidate_selection',
            candidate: !checked ? candidate : null,
            index: idx,
        })
    }

    return (
        <div
            className="candidate-card"
            onClick={(e) => {
                clickHandler(candidate)
            }}
        >
            <div className="candidate-card__container">
                <div className="candidate-card__row">
                    <div className="candidate-card__checkbox-col">
                        <Form.Check
                            className="candidate-checkbox "
                            type="checkbox"
                            value={candidate.name}
                            name={candidate.name}
                            checked={checked}
                            onChange={handleCheckboxChange}
                            onClick={(event) => event.stopPropagation()}
                        />
                    </div>
                    <div className="candidate-card__info-col">
                        <span className="candidate-info-text candidate-name">
                            {`${capitalizeFirstLetter(
                                candidate.first_name
                            )} ${capitalizeFirstLetter(candidate.last_name)}`}
                        </span>
                        {candidate.company_position && (
                            <span className="candidate-info-text candidate-title-location">
                                {candidate.company_position}
                            </span>
                        )}
                        {candidate.current_company && (
                            <span className="candidate-info-text candidate-current-company">
                                <strong>Current Company:</strong>
                                {candidate.current_company}
                            </span>
                        )}
                        {candidate.school && (
                            <span className="candidate-info-text candidate-education">
                                <strong>Education:</strong> {candidate.school}
                            </span>
                        )}
                        {!isEmpty(candidate.skills) && (
                            <span className="candidate-info-text candidate-status">
                                <strong>Skills: </strong>
                                {candidate.skills}
                            </span>
                        )}
                        <span className="candidate-info-text candidate-status">
                            <strong>Active:</strong>
                            {candidate.active ? 'Yes' : 'No'}
                        </span>
                    </div>
                    {candidate.submission && candidate.submission.created_at && (
                        <div className="candidate-card__applied-col">
                            <span className="candidate-span">
                                Date applied:
                            </span>
                            <span className="candidate-date-text">
                                {moment(candidate.submission.created_at).format(
                                    'MM/DD/YY'
                                )}
                            </span>
                        </div>
                    )}
                    {candidate.last_contacted && (
                        <div className="candidate-card__contacted-col">
                            <span className="candidate-span">
                                Last Contacted:
                            </span>
                            <span className="candidate-date-text">
                                {moment(candidate.last_contacted).format(
                                    'MM/DD/YY'
                                )}
                            </span>
                        </div>
                    )}
                    <div className="candidate-card__progress-col">
                        <CircularProgressbarWithChildren
                            strokeWidth="5"
                            value={candidate.score || 0}
                        >
                            <span className="progress-value">
                                {candidate.score || 0}%
                            </span>
                            <span className="match-span">Match</span>
                        </CircularProgressbarWithChildren>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default CandidateCard
