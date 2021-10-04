import React, { useEffect } from 'react'
import styles from './styles/JobSearchBar.module.scss'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import FormControl from 'react-bootstrap/FormControl'
import Image from 'react-bootstrap/Image'
import Button from 'react-bootstrap/Button'
import SearchIcon from '../../../../assets/images/talent_page_assets/search-icon-new.png'

function JobSearchBar({
    placeholder,
    value,
    onChange,
    onEnterPressed,
    onButtonClick,
}) {
    return (
        <Row>
            <Col lg={4} md={4} sm={1}> </Col>
            <Col lg={4} md={4} sm={10} xs={12}>
                <FormControl
                    id="inlineFormInputGroup"
                    placeholder={placeholder}
                    style={{ textIndent: '40px' }}
                    className={styles.placeholderText}
                    value={value}
                    onChange={onChange}
                    onKeyPress={(e) => {
                        if (e.key === 'Enter') {
                            onEnterPressed(e)
                        }
                    }}
                />

                <div
                    style={{
                        position: 'absolute',
                        left: '30px',
                        top: '18px',
                        zIndex: '2',
                        height:'25px',
                        width:'25px'
                    }}
                >
                    <Image src={SearchIcon} fluid />
                </div>
            </Col>
            <Col lg={4} md={4} sm={1} ></Col>
        </Row>
    )
}

export default JobSearchBar
