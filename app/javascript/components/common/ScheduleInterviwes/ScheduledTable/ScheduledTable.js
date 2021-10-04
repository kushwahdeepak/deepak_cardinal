import React, { Fragment, useEffect, useState } from 'react'
import { Table, Row, Col } from 'react-bootstrap'
import styles from './styles/ScheduledTable.module.scss'
import Paginator from '../../../common/Paginator/Paginator'
import feather from 'feather-icons'

import SheduledTableBody from './SheduledTableBody'

function ScheduledTable({ columns, data,user,jobs,isMyInterviwes }) {
    return (
        <Fragment>
            <SheduledTableBody interviews={data} user={user} jobs={jobs} myInterview={isMyInterviwes}/>
        </Fragment>
    )
}

export default ScheduledTable