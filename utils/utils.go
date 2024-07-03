package utils

import (
	"context"
	"errors"
	"log"
	"os"

	"github.com/go-chi/jwtauth"
	"github.com/golang-jwt/jwt/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"golang.org/x/crypto/bcrypt"
)

var TokenAuth *jwtauth.JWTAuth

func HashPassword(plainPass string) (string, error) {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(plainPass), 14)
	return string(hashedPassword), err
}

func CheckPasswordMatch(hashedPassword, enteredPassword string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(enteredPassword))
	return err == nil
}

func TestDB(db *pgxpool.Pool) error {
	test_data := "test_data.sql"

	script, err := os.ReadFile(test_data)
	if err != nil {
		return err
	}
	_, err = db.Exec(context.Background(), string(script))
	if err != nil {
		return err
	}

	log.Println("test data inserted successfully")
	return nil
}

func SetTokenAuth(secretKey string) error {
	if secretKey == "" {
		return errors.New("JWT_SECRET_KEY environment variable not found")
	}
	TokenAuth = jwtauth.New("HS256", []byte(secretKey), nil)
	return nil
}

func GenerateJWT(claims map[string]interface{}) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims(claims))
	tokenString, err := token.SignedString([]byte(os.Getenv("JWT_SECRET_KEY")))
	if err != nil {
		return "", err
	}
	return tokenString, nil
}
