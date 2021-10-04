import React, { useState, useEffect, useRef } from 'react'
import Button from 'react-bootstrap/Button'
import Image from 'react-bootstrap/Image'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import feather from 'feather-icons'
import styles from './styles/NoOrganization.module.scss'

const NoOrganization = () => {
    return (
        <div className={styles.errorPage}>
            <section className={styles.getStartedSection}>
                <Row className={styles.newRow}>
                    <Col md="12" lg="12" className={styles.getStartedColumn}>
                        <div>
                        <h1 className={styles.title}>
                                Oops!
                            </h1>
                            <p className={styles.subtitle}>
                                Sorry. Not assigned any organization to you.
                            </p>
                        </div>
                    </Col>
                   
                </Row>
            </section>
        </div>    
    )
}
export default NoOrganization
