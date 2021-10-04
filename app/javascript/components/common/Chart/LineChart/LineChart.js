import React from 'react'
import {
    LineChart,
    ResponsiveContainer,
    XAxis,
    YAxis,
    CartesianGrid,
    Line,
} from 'recharts'

import { Row } from 'react-bootstrap'

import styles from './style/LineChart.module.scss'
const TICK_STYLE = {
    fontSize: 11,
    fill: 'rgba(77, 104, 255, 1)',
    fontFamily: 'Avenir',
}

function Chart({ data, legends }) {
    return (
        <Row className={styles.lineChartContainer}>
            <div style={{ height: '270px', width: '80%' }}>
                <ResponsiveContainer width="100%">
                    <LineChart width={730} height={250} data={data}>
                        <CartesianGrid stroke="#DCDFFA" strokeWidth={1} />
                        <XAxis
                            stroke="rgba(0,0,0,0.05)"
                            strokeWidth={2}
                            tick={TICK_STYLE}
                            tickLine={false}
                            dataKey="date"
                        />
                        <YAxis
                            stroke="rgba(0,0,0,0.05)"
                            strokeWidth={2}
                            tick={TICK_STYLE}
                            tickLine={false}
                            tickMargin={0}
                        />

                        {legends.map((bar, index) => {
                            return (
                                <Line
                                    key={index}
                                    type="monotone"
                                    dataKey={bar.key}
                                    stroke={bar.fill}
                                />
                            )
                        })}
                    </LineChart>
                </ResponsiveContainer>
            </div>
            { data.length > 0 && <div className={styles.keysContainer}>
                <span className={styles.keyText}>Key :</span>
                <div className={styles.keyItems}>
                    {legends.map((bar, index) => (
                        <div key={index} className={styles.key}>
                            <span
                                style={{
                                    backgroundColor: `${bar.fill}`,
                                }}
                                className={styles.colorBox}
                            ></span>
                            {bar.name}
                        </div>
                    ))}
                </div>
            </div>}
        </Row>
    )
}

export default Chart
