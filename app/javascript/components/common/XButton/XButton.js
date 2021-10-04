import React, { useEffect } from 'react'
import styles from './styles/XButton.module.scss'
import feather from 'feather-icons'

function XButton({ onClick }) {
    useEffect(() => {
        feather.replace()
    })

    return (
        <button className={styles.x} onClick={onClick}>
            <i data-feather="x" width="15px" height="15px"></i>
        </button>
    )
}

export default XButton
