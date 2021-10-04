import React from 'react'
import styles from './styles/MatchScore.module.scss'

function MatchScore({ score, big = false }) {
    let mainClassName = score ? 'matchText' : 'noMatchText'
    if (big) mainClassName += '_big'

    return (
        <div className={styles[mainClassName]} style={{ margin: 'auto' }}>
            {score ? (
                <span
                    style={{
                        display: 'flex',
                        flexDirection: 'column',
                    }}
                >
                    {score}%{' '}
                    <span
                        className={
                            big ? styles.matchSubText_big : styles.matchSubText
                        }
                    >
                        Match
                    </span>
                </span>
            ) : (
                <span>
                    Not yet <br /> matched
                </span>
            )}
        </div>
    )
}

export default MatchScore
