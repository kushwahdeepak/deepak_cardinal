import React, { useContext } from 'react'
import Dropdown from 'react-bootstrap/Dropdown'
import { StoreDispatchContext } from '../../../stores/JDPStore'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import { allStages } from '../../../misc/gconst'
import './styles/StageSelector.scss'

function StageSelector({
    allSelectedCandidates,
    refreshCandidates,
    jobId,
    stage,
}) {
    const { state } = useContext(StoreDispatchContext)

    async function changeStage(stage, jobId, allSelectedCandidates, userId) {
        const url = '/submissions/change_stage'
        const candidate_ids = allSelectedCandidates.map(
            (candidate) => candidate.id
        )

        if (candidate_ids.length == 0) return

        const payload = JSON.stringify({
            user_id: userId,
            job_id: jobId,
            candidate_ids,
            stage,
        })

        await makeRequest(url, 'put', payload, {
            loadingMessage: 'Submitting...',
            createSuccessMessage: (response) =>
                `Candidate${
                    candidate_ids.length > 1 ? 's' : ''
                } successfully moved`,
        })
        setTimeout(() => {
            window.location.href = `/jobs/${jobId}` 
        }, 300)
    }

    return (
            <Dropdown>
                <Dropdown.Toggle className="changeStageDropdown">
                    Move selected to
                </Dropdown.Toggle>
                <Dropdown.Menu>
                    {menuItemsForStage(stage).map((itemData,index) => (
                        <Dropdown.Item
                            key={index}
                            onClick={async (e) => {
                                e.preventDefault()

                                await changeStage(
                                    itemData.id,
                                    jobId,
                                    allSelectedCandidates,
                                    state.user.id
                                )

                                refreshCandidates()
                            }}
                        >
                            {itemData.label}
                        </Dropdown.Item>
                    ))}
                </Dropdown.Menu>
            </Dropdown>
    )
}

function menuItemsForStage(activeStage) {
    return allStages.filter((stageData) => stageData.id !== activeStage)
}

export default StageSelector
