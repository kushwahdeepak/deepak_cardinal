import React, { useState, useEffect } from 'react'
import axios from 'axios'
import Select from 'react-select'

import './style/RecruiterOrganization.scss'
import {colourStyles} from './style/RecruiterOrganization.styles'

function RecruiterOrganization({
    recruiterOrganizations,
    organization,
    handleChangeOrganization,
}) {
    const [jobData, setJobData] = useState({})
    const job_id = location.href.split('/')[4]
    const url = `/organization_name/${job_id}`
    // const defultOrganization =
    const recruiterOrganizationsArray = recruiterOrganizations.map(
        (recruiterOrganization) => {
            return {
                value: recruiterOrganization.id,
                label: recruiterOrganization.name,
            }
        }
    )

    useEffect(() => {
        if (job_id !== 'new' && job_id !== undefined) {
            const fetchData = async () => {
                const result = await axios(url)
                setJobData(result.data)
            }
            fetchData()
        }
    }, [])

    return (
        <>
            <Select
                className="basic-single"
                classNamePrefix="select"
                isSearchable={true}
                name="color"
                styles={colourStyles}
                onChange={(event) => handleChangeOrganization(event.value)}
                options={recruiterOrganizationsArray}
                value={
                    organization
                        ? recruiterOrganizationsArray.filter(
                              (recruiterOrganization) =>
                                  recruiterOrganization.value ===
                                  organization?.id
                          )
                        : { value: jobData.id, label: jobData.name }
                }
            />
        </>
    )
}

export default RecruiterOrganization
