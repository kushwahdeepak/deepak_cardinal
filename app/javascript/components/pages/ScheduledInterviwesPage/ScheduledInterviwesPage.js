import React, { useState } from 'react'

import styles from './stryles/ScheduledInterviwesPage.module.scss'
import ScheduledInterviwes from '../../common/ScheduleInterviwes/ScheduledInterviwes'
import NoOrganization from '../EmployerDashboard/NoOrganization'

function ScheduledInterviwesPage({ personId,user,jobs }) {
    if(user?.organization_id)
        return (
            <div className={styles.container}>
                <ScheduledInterviwes  personId={personId} user={user} jobs={jobs} scheduledInterviewPage={true}/>
            </div>
        )
    else return <NoOrganization/>
}

export default ScheduledInterviwesPage
