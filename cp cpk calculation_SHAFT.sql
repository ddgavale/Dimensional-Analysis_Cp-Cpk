# 1. CREATE DB
create database meas_data;

# 2. USE DB
use meas_data;

# 🛠️ 3.Create Table in MySQL DB
CREATE TABLE measurements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    parameter_name VARCHAR(100),
    measurement_point VARCHAR(10),   -- e.g., 'T1' or 'T2'
    measurement FLOAT,
    nominal FLOAT,
    upper_tol FLOAT,
    lower_tol FLOAT
);

# 📥 4. Load CSV into MySQL

SELECT * FROM measurements;  
-- as showing measurements table heads use Import/Export icon to insert data manually

SELECT * FROM measurements;  

# 5. Calculate the mean (μ) and standard deviation (σ)
/*
🔹 Mean (μ) —> Average: X₁, X₂, X₃, ..., Xn , Mean is (X₁+ X₂+ X₃) / Xn

🔹 Standard Deviation (σ) —> Population:
				MySQL code:
SELECT
    AVG(measurement) AS mean,
    STDDEV_POP(measurement) AS std_dev
FROM measurements
WHERE parameter_name = 'HOLE Ø8 mm';

				In Excel:
Assume values in column A2:A126:

Formula	Description
=AVERAGE(A2:A126)	Mean (μ)
=STDEVP(A2:A126)	Standard Deviation (σ, population)
*/

# 📐 6. Calculate Cp and Cpk in MySQL
	# 🧪 What Are Cp and Cpk?
    /*
| Metric  | Meaning                                        | Formula                                     |
| ------- | ---------------------------------------------- | ------------------------------------------- |
| **Cp**  | Potential process capability (centered)        | $Cp = (USL - LSL) / (6 × σ)$                |
| **Cpk** | Actual process capability (accounts for shift) | $Cpk = min((USL - μ), (μ - LSL)) / (3 × σ)$ | 

*/

SELECT
    parameter_name,
    COUNT(*) AS count,
    ROUND(STDDEV_POP(measurement), 6) AS std_dev,
    
    ROUND(
        (MAX(nominal + upper_tol) - MIN(nominal + lower_tol)) / 
        (6 * NULLIF(STDDEV_POP(measurement), 0)), 6
    ) AS Cp,
    
    ROUND(
        LEAST(
            MAX(nominal + upper_tol) - AVG(measurement),
            AVG(measurement) - MIN(nominal + lower_tol)
        ) / (3 * NULLIF(STDDEV_POP(measurement), 0)), 6
    ) AS Cpk

FROM
    measurements
GROUP BY
    parameter_name;

