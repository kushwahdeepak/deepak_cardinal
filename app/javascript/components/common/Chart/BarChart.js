import React from 'react'

import {
    BarChart,
    ResponsiveContainer,
    XAxis,
    YAxis,
    CartesianGrid,
    Bar,
} from 'recharts'
const TICK_STYLE = {
    fontSize: 11,
    fill: 'rgba(77, 104, 255, 1)',
    fontFamily: 'Avenir',
}

const Chart = ({ data}) => (
    <div style={{ height: '435px', width: '90%', marginLeft: 20 }}>
        <ResponsiveContainer>
            <BarChart data={data} layout="vertical" margin={{ top: 30 }}>
                <XAxis
                    stroke="rgba(0,0,0,0.05)"
                    strokeWidth={2}
                    tick={TICK_STYLE}
                    tickLine={false}
                    type="number"
                />
                <YAxis
                    dataKey="name"
                    stroke="rgba(0,0,0,0.05)"
                    strokeWidth={2}
                    tick={TICK_STYLE}
                    tickLine={false}
                    tickMargin={0}
                    type="category"
                    width={80}
                />
                <CartesianGrid
                    stroke="#DCDFFA"
                    strokeWidth={1}
                />
                <Bar barSize={15} dataKey="count" fill="#6C9E57" />
            </BarChart>
        </ResponsiveContainer>
    </div>
)
export default Chart