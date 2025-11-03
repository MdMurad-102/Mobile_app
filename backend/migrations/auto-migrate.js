// Auto Migration - Creates tables if they don't exist
// This runs automatically when the server starts

const { Pool } = require('pg');

async function autoMigrate(pool) {
    console.log('🔍 Checking database tables...\n');

    try {
        // Create tables if they don't exist
        await pool.query(`
            -- Users table
            CREATE TABLE IF NOT EXISTS users (
                id SERIAL PRIMARY KEY,
                email VARCHAR(255) UNIQUE NOT NULL,
                name VARCHAR(255) NOT NULL,
                password VARCHAR(255),
                picture TEXT,
                subscription_id VARCHAR(255),
                credit INTEGER DEFAULT 0,
                weight VARCHAR(50),
                height VARCHAR(50),
                gender VARCHAR(20),
                goal VARCHAR(100),
                age VARCHAR(10),
                calories INTEGER,
                proteins INTEGER,
                country VARCHAR(100),
                city VARCHAR(100),
                diet_type VARCHAR(100),
                daily_water_goal INTEGER DEFAULT 8,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );

            -- Water tracking table
            CREATE TABLE IF NOT EXISTS water_tracking (
                id SERIAL PRIMARY KEY,
                user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                date DATE NOT NULL,
                water_consumed INTEGER DEFAULT 0,
                last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                UNIQUE(user_id, date)
            );

            -- Scheduled meals table
            CREATE TABLE IF NOT EXISTS scheduled_meals (
                id SERIAL PRIMARY KEY,
                user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                scheduled_date DATE NOT NULL,
                meal_type VARCHAR(50) NOT NULL,
                meal_plan_data JSONB,
                total_calories INTEGER DEFAULT 0,
                total_protein INTEGER DEFAULT 0,
                meals_consumed TEXT[],
                date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );

            -- Progress tracking table
            CREATE TABLE IF NOT EXISTS progress_tracking (
                id SERIAL PRIMARY KEY,
                user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                date DATE NOT NULL,
                weight DECIMAL(5,2),
                body_fat DECIMAL(5,2),
                muscle_mass DECIMAL(5,2),
                notes TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );

            -- Weight goals table
            CREATE TABLE IF NOT EXISTS weight_goals (
                id SERIAL PRIMARY KEY,
                user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                current_weight DECIMAL(5,2) NOT NULL,
                target_weight DECIMAL(5,2) NOT NULL,
                start_weight DECIMAL(5,2) NOT NULL,
                goal_date DATE,
                weekly_goal DECIMAL(5,2),
                is_active BOOLEAN DEFAULT true,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );

            -- Daily nutrition table
            CREATE TABLE IF NOT EXISTS daily_nutrition (
                id SERIAL PRIMARY KEY,
                user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                date DATE NOT NULL,
                calories_consumed INTEGER DEFAULT 0,
                protein_consumed INTEGER DEFAULT 0,
                carbs_consumed INTEGER DEFAULT 0,
                fat_consumed INTEGER DEFAULT 0,
                fiber_consumed INTEGER DEFAULT 0,
                sugar_consumed INTEGER DEFAULT 0,
                sodium_consumed INTEGER DEFAULT 0,
                meals_logged INTEGER DEFAULT 0,
                last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                UNIQUE(user_id, date)
            );

            -- Daily tasks table
            CREATE TABLE IF NOT EXISTS daily_tasks (
                id SERIAL PRIMARY KEY,
                user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                date DATE NOT NULL,
                task_id VARCHAR(100) NOT NULL,
                completed BOOLEAN DEFAULT false,
                current_value INTEGER DEFAULT 0,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                UNIQUE(user_id, date, task_id)
            );

            -- Weight logs table
            CREATE TABLE IF NOT EXISTS weight_logs (
                id SERIAL PRIMARY KEY,
                user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                weight DECIMAL(5,2) NOT NULL,
                date DATE NOT NULL,
                notes TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );

            -- Create indexes for better performance
            CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
            CREATE INDEX IF NOT EXISTS idx_water_tracking_user_date ON water_tracking(user_id, date);
            CREATE INDEX IF NOT EXISTS idx_scheduled_meals_user_date ON scheduled_meals(user_id, scheduled_date);
            CREATE INDEX IF NOT EXISTS idx_progress_tracking_user_date ON progress_tracking(user_id, date);
            CREATE INDEX IF NOT EXISTS idx_weight_goals_user ON weight_goals(user_id) WHERE is_active = true;
            CREATE INDEX IF NOT EXISTS idx_daily_nutrition_user_date ON daily_nutrition(user_id, date);
            CREATE INDEX IF NOT EXISTS idx_daily_tasks_user_date ON daily_tasks(user_id, date);
        `);

        console.log('✅ Database tables verified/created successfully!\n');
        console.log('📊 Available tables:');
        console.log('   - users');
        console.log('   - water_tracking');
        console.log('   - scheduled_meals');
        console.log('   - progress_tracking');
        console.log('   - weight_goals');
        console.log('   - daily_nutrition');
        console.log('   - daily_tasks');
        console.log('   - weight_logs\n');

        return true;
    } catch (error) {
        console.error('❌ Auto-migration failed:', error);
        return false;
    }
}

module.exports = { autoMigrate };
